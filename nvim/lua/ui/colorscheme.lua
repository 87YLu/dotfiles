-- https://github.com/folke/tokyonight.nvim
local status_ok, tokyonight = pcall(require, 'tokyonight')

if not status_ok then
  vim.notify('tokyonight not found!')
  return
end

tokyonight.setup({
  style = 'night',
  transparent = true,
  on_colors = function(colors)
    colors.comment = '#737881'
    colors.bg_visual = '#3a4150'
  end,
})

-- transparent 设为 true 时必须指定 background_colour
require('notify').setup({
  background_colour = '#414868',
})

vim.cmd('colorscheme tokyonight')
