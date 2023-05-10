-- https://github.com/nvim-telescope/telescope.nvim
local status_ok, telescope = pcall(require, 'telescope')

if not status_ok then
  vim.notify('telescope not found!')
  return
end

telescope.setup({
  defaults = {
    -- 打开弹窗后进入的初始模式，默认为 insert，也可以是 normal
    initial_mode = 'insert',
    -- 窗口内快捷键
    mappings = require('basic.keymaps').telescope_keys,
  },
})

telescope.load_extension('ui-select')
