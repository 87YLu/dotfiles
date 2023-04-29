-- https://github.com/sindrets/diffview.nvim
local status_ok, diffview = pcall(require, 'diffview')

if not status_ok then
  vim.notify('diffview not found!')
  return
end

diffview.setup({
  hooks = {
    -- diffview 会跟 coc 插件冲突，进入时先禁用 coc
    -- https://github.com/neoclide/coc.nvim/issues/1183
    view_opened = function()
      vim.cmd('CocDisable')
      vim.cmd('Noice dismiss')
    end,
    view_closed = function(view)
      if view.tabpage == 2 then
        vim.cmd('CocEnable')
        vim.cmd('Noice dismiss')
      end
    end,
  },
})
