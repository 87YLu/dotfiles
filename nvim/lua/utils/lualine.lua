---@class UtilsLualine
local M = {}

---@return string
M.lsp_breadcrumb = function()
  local ok, lspsaga = pcall(require, 'lspsaga.symbol.winbar')
  return '     ' .. (ok and lspsaga.get_bar() or ' ')
end

---@param lualine? table
---@return fun(): string
M.language_server = function(lualine)
  local spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  local spinner_index = 0
  local progress_clients = {}

  local refresh = lualine and function()
    lualine.refresh({ scope = 'tabpage', place = { 'statusline' } })
  end or function() end

  vim.api.nvim_create_autocmd('LspProgress', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end

      local val = ev.data.params.value
      local key = ev.data.params.token
      local name = client.name

      if not progress_clients[name] then
        progress_clients[name] = {}
      end

      if val.kind == 'begin' or val.kind == 'report' then
        progress_clients[name][key] = true
      elseif val.kind == 'end' then
        progress_clients[name][key] = nil
        if next(progress_clients[name]) == nil then
          progress_clients[name] = nil
        end
      end

      refresh()
    end,
  })

  vim.api.nvim_create_autocmd('LspDetach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client then
        progress_clients[client.name] = nil
      end
      refresh()
    end,
  })

  return function()
    local buf_ft = vim.bo.filetype
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then
      return ''
    end

    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        local icon = require('nvim-web-devicons').get_icon_by_filetype(buf_ft) or ''
        local name = client.name
        local result = icon .. ' ' .. name

        if progress_clients[name] and next(progress_clients[name]) then
          spinner_index = (spinner_index % #spinner_symbols) + 1
          result = result .. ' ' .. spinner_symbols[spinner_index]
        end

        return result
      end
    end

    return ''
  end
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
          local editor = has_trae and 'trae' or 'code'
          local project = vim.fn.shellescape(Utils.Path.get_project_root())
          local file = vim.fn.shellescape(Utils.Path.get_current_path())
          vim.fn.system(('%s %s --goto %s'):format(editor, project, file))
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
          local git_root = Utils.Path.get_git_root()
          if git_root then
            vim.fn.system('smerge ' .. vim.fn.shellescape(git_root))
          else
            vim.notify('Not inside a git repository', vim.log.levels.WARN)
          end
        end, 200)
      end,
    }
  or {}

return M
