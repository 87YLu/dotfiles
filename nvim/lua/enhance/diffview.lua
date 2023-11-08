-- https://github.com/sindrets/diffview.nvim
local status_ok, diffview = pcall(require, 'diffview')

if not status_ok then
  vim.notify('diffview not found!')
  return
end

vim.g.is_diffview_opening = false

local file_utils = require('utils.file')
local current_file_utils = require('utils.current_file')

function Open_file_at_diffview_panel()
  local lib = require('diffview.lib')
  local file = lib.get_current_view():infer_cur_file()

  if not file then
    return
  end

  if file_utils.is_exist(file.path) then
    vim.cmd('DiffviewClose')
    vim.cmd(':e ' .. file.path)
  else
    vim.notify('the file has been deleted.')
  end
end

diffview.setup({
  hooks = {
    -- diffview 会跟 coc 插件冲突，进入时先禁用 coc
    view_opened = function()
      vim.cmd('CocDisable')
      vim.cmd('Noice dismiss')
      vim.g.is_diffview_opening = true
    end,
    view_closed = function()
      vim.cmd('CocEnable')
      vim.cmd('Noice dismiss')
      vim.g.is_diffview_opening = false
    end,
    diff_buf_read = function(bufnr)
      local is_diffview = string.sub(current_file_utils.path(), 1, string.len('diffview://')) == 'diffview://'

      if is_diffview then
        vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
      end

      vim.opt_local.foldlevel = 99
      vim.opt_local.foldenable = false
    end,
    diff_buf_win_enter = function(bufnr, ctx)
      vim.opt_local.foldlevel = 99
      vim.opt_local.foldenable = false
    end,
  },
  keymaps = {
    file_panel = {
      { 'n', 'o', Open_file_at_diffview_panel, { desc = 'open file' } },
      { 'n', 'gf', function() end },
    },
  },
})

function _G.view_file_diff()
  if vim.g.is_diffview_opening then
    vim.cmd('DiffviewClose')
  else
    vim.cmd('DiffviewOpen')
  end
end

function _G.view_file_history()
  if vim.g.is_diffview_opening then
    vim.cmd('DiffviewClose')
  else
    vim.cmd('DiffviewFileHistory %')
  end
end

function _G.view_git_history()
  if vim.g.is_diffview_opening then
    vim.cmd('DiffviewClose')
  else
    vim.cmd('DiffviewFileHistory')
  end
end
