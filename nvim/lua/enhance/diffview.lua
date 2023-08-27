-- https://github.com/sindrets/diffview.nvim
local status_ok, diffview = pcall(require, 'diffview')

if not status_ok then
  vim.notify('diffview not found!')
  return
end

vim.g.is_diffview_opening = false

function Open_file_at_diffview_panel()
  local lib = require('diffview.lib')
  local file = lib.get_current_view():infer_cur_file()

  if not file then
    return
  end

  local exist = io.open(file.path, 'rb')

  if not exist then
    vim.notify('the file has been deleted.')
    return
  end

  exist:close()
  vim.cmd('DiffviewClose')
  vim.cmd(':e ' .. file.path)
end

diffview.setup({
  hooks = {
    -- diffview 会跟 coc 插件冲突，进入时先禁用 coc
    -- https://github.com/neoclide/coc.nvim/issues/1183
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
