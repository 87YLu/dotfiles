local M = {}

M.lsp_progress = function(lualine)
  local refresh = lualine and lualine.refresh({
    scope = 'tabpage',
    place = { 'statusline' },
  }) or function() end

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
    lsp_client_name = { pre = ' ', post = ' ' },
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

    return #progress_message > 60 and (string.sub(progress_message, 1, 60) .. '...') or progress_message
  end
end

M.lsp_breadcrumb = function()
  local ok, lspsaga = pcall(require, 'lspsaga.symbol.winbar')
  return '     ' .. (ok and lspsaga.get_bar() or ' ')
end

M.language_server = function()
  local msg = ''
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      local icon = require('nvim-web-devicons').get_icon_by_filetype(buf_ft)
      return icon .. ' ' .. client.name
    end
  end
  return msg
end

local has_trae = vim.fn.executable('trae') == 1
local has_vs_code = vim.fn.executable('code') == 1

M.open_ide = (has_trae or has_vs_code)
    and {
      function()
        return has_trae and '󱙺 TRAE' or '󰨞 VSCode'
      end,
      color = {
        fg = has_trae and '#32f08b' or '#3790E9',
      },
      on_click = function()
        vim.notify('Open ' .. (has_trae and 'TRAE' or 'VScode'))
        vim.defer_fn(function()
          vim.fn.system(
            (has_trae and 'trae ' or 'code ')
              .. Utils.Path.get_project_root()
              .. ' --goto '
              .. Utils.Path.get_current_path()
          )
        end, 200)
      end,
    }
  or {}

M.open_sublime_merge = vim.fn.executable('smerge') == 1
    and {
      function()
        return ' Sublime Merge'
      end,
      color = {
        fg = '#74dde2',
      },
      on_click = function()
        vim.notify('Open Sublime Merge')
        vim.defer_fn(function()
          vim.fn.system('smerge ' .. Utils.Path.get_git_root())
        end, 200)
      end,
    }
  or {}

return M
