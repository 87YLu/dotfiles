---@class UtilsLualine
local M = {}

---@return string
M.lsp_breadcrumb = function()
  local ok, lspsaga = pcall(require, 'lspsaga.symbol.winbar')
  return '     ' .. (ok and lspsaga.get_bar() or ' ')
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
