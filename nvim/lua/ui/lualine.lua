-- https://github.com/nvim-lualine/lualine.nvim
local Lsp_progress = function(refresh)
  local spinner_symbols = { '⠋ ', '⠙ ', '⠹ ', '⠸ ', '⠼ ', '⠴ ', '⠦ ', '⠧ ', '⠇ ', '⠏ ' }

  local function createCounter()
    local count = 0
    return function()
      count = (count % #spinner_symbols) + 1
      return count
    end
  end

  local get_spinner_index = createCounter()

  local separators = {
    component = '',
    progress = ' | ',
    message = { pre = '(', post = ')' },
    percentage = { pre = '', post = '%% ' },
    title = { pre = '', post = ' ' },
    lsp_client_name = { pre = ' [', post = '] ' },
    spinner = { pre = '', post = '' },
  }

  local clients = {}

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers['$/progress'] = function(...)
    refresh()
    local arg = select(4, ...)
    local msg = type(arg) ~= 'number' and select(2, ...) or select(3, ...)
    local client_id = type(arg) ~= 'number' and select(3, ...).client_id or arg

    local key = msg.token
    local val = msg.value
    local client_name = vim.lsp.get_client_by_id(client_id).name
    if not key then
      return
    end

    if clients[client_name] == nil then
      clients[client_name] = { progress = {} }
    end

    local progress_collection = clients[client_name].progress

    if progress_collection[key] == nil then
      progress_collection[key] = { title = nil, message = nil, percentage = nil }
    end

    local progress = progress_collection[key]

    if val then
      if val.kind == 'begin' then
        progress.title = val.title
        progress.completed = false
      end
      if val.kind == 'report' then
        if val.percentage then
          progress.percentage = val.percentage
        end
        if val.message then
          progress.message = val.message
        end
        progress.completed = false
      end
      if val.kind == 'end' then
        progress.completed = true

        if clients[client_name] then
          clients[client_name].progress[key] = nil
        end
      end
    end
  end

  return function()
    local result = {}

    local progress_message = ''

    local is_all_completed = true

    for client_name, client in pairs(clients) do
      table.insert(result, separators.lsp_client_name.pre .. client_name .. separators.lsp_client_name.post)

      local p = {}
      for _, progress in pairs(client.progress or {}) do
        if not progress.completed then
          is_all_completed = false
        end
        if progress.title then
          local d = {}
          for _, i in pairs({ 'title', 'percentage', 'message' }) do
            if progress[i] and progress[i] ~= '' then
              table.insert(d, separators[i].pre .. progress[i] .. separators[i].post)
            end
          end
          table.insert(p, table.concat(d, ''))
        end
      end

      if not is_all_completed then
        table.insert(result, spinner_symbols[get_spinner_index()])
      end

      table.insert(result, table.concat(p, separators.progress))
    end

    if #result > 0 then
      progress_message = table.concat(result, separators.component)
    else
      progress_message = ''
    end

    return progress_message
  end
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local lualine = require('lualine')
    local hbac = require('hbac.state')
    local common_utils = require('utils.common')
    local color_utils = require('utils.color')
    local file_utils = require('utils.file')

    local get_color = function(color)
      return {
        fg = color_utils.get_color_fg(color, true),
      }
    end

    local refresh = function()
      require('lualine').refresh({
        scope = 'tabpage',
        place = { 'statusline' },
      })
    end

    local lsp_progress = Lsp_progress(refresh)

    local lsp_breadcrumb = function()
      return '     ' .. (require('lspsaga.symbol.winbar').get_bar() or '')
    end

    local config = {
      options = {
        component_separators = '',
        section_separators = '',
        disabled_filetypes = {
          tabline = { 'alpha', 'neo-tree', 'sagaoutline' },
          statusline = { 'alpha', 'DiffviewFiles', 'sagaoutline' },
          winbar = { 'neo-tree', 'alpha', 'DiffviewFiles', 'sagaoutline' },
        },
      },
      extensions = { 'neo-tree', 'toggleterm' },
      sections = {
        lualine_a = { { 'mode' } },
        lualine_b = {},
        lualine_c = {
          {
            'branch',
            icon = '',
            color = function()
              return get_color('@tag')
            end,
            padding = { left = 2, right = 1 },
          },
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
            padding = { left = 1, right = 1 },
          },
          {
            lsp_progress,
            color = function()
              return get_color('LuaLineLspColor')
            end,
          },
        },
        lualine_x = {
          -- {
          --   function()
          --     local msg = ''
          --     local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
          --     local clients = vim.lsp.get_active_clients()
          --     if next(clients) == nil then
          --       return msg
          --     end
          --     for _, client in ipairs(clients) do
          --       local filetypes = client.config.filetypes
          --       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          --         local icon = require('nvim-web-devicons').get_icon_by_filetype(buf_ft)
          --         return icon .. ' ' .. client.name
          --       end
          --     end
          --     return msg
          --   end,
          -- },
          {
            'encoding',
            fmt = function(str)
              return string.upper(str)
            end,
            color = function()
              return get_color('@repeat')
            end,
          },
          {
            'fileformat',
            symbols = {
              unix = 'LF',
              dos = 'CRLF',
              mac = 'CR',
            },
            color = function()
              return get_color('@annotation')
            end,
          },
          {
            function()
              local success, result = pcall(function()
                local status = vim.fn['codeium#GetStatusString']():match('^%s*(.-)%s*$')
                return status == 'ON' and '󱜙 Codeium' or '󱚢 Codeium'
              end)
              return success and result or ''
            end,
            color = function()
              local success, result = pcall(function()
                local status = vim.fn['codeium#GetStatusString']():match('^%s*(.-)%s*$')
                return status == 'ON' and get_color('@character.special') or get_color('Comment')
              end)
              return success and result or get_color('Comment')
            end,
            on_click = function()
              vim.cmd('CodeiumToggle')
            end,
          },
          {
            function()
              return hbac.autoclose_enabled and '󰅗 hbac' or '󰅘 hbac'
            end,
            color = function()
              return hbac.autoclose_enabled and get_color('@string.regex') or get_color('Comment')
            end,
          },
          {
            function()
              return '󰨞 Open'
            end,
            color = {
              fg = '#3790E9',
            },
            on_click = function()
              vim.cmd('!code ' .. common_utils.cwd() .. ' --goto ' .. file_utils.current_path())
            end,
            padding = { left = 1, right = 2 },
          },
        },
        lualine_y = {},
        lualine_z = { { 'location' } },
      },
      winbar = {
        lualine_c = {
          lsp_breadcrumb,
        },
        lualine_x = {
          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          lsp_breadcrumb,
        },
        lualine_x = {
          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
            diff_color = {
              added = function()
                return get_color('diffAdded')
              end,
              modified = function()
                return get_color('diffChanged')
              end,
              removed = function()
                return get_color('diffRemoved')
              end,
            },
          },
        },
      },
    }

    lualine.setup(config)
  end,
}
