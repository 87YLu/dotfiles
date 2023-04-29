-- https://github.com/folke/tokyonight.nvim
local status_ok, tokyonight = pcall(require, 'tokyonight')

if not status_ok then
  vim.notify('tokyonight not found!')
  return
end

tokyonight.setup({
  style = 'night',
  transparent = true,
})

-- transparent 设为 true 时必须指定 background_colour
require('notify').setup({
  background_colour = '#66ccff',
})

vim.cmd('colorscheme tokyonight')
