-- https://github.com/folke/tokyonight.nvim
local colorschemes = vim.g.colorschemes
local colorscheme = vim.g.colorscheme

vim.cmd(':highlight CocInlayHint guifg=#4c4c4c gui=bold,italic,underline')
vim.cmd(':highlight CursorLineNr gui=italic,bold')

if colorscheme == colorschemes.tokyonight then
  require('tokyonight').setup({
    style = 'night',
    transparent = true,
    on_colors = function(colors)
      colors.comment = '#737881'
      colors.bg_visual = '#303F9F'
    end,
  })

  -- background_colour must be specified if transparent is true.
  require('notify').setup({
    background_colour = '#414868',
  })

  vim.cmd('colorscheme tokyonight')
  return
end

-- https://github.com/catppuccin/nvim
if colorscheme == colorschemes.catppuccin then
  require('catppuccin').setup({
    flavour = 'macchiato', -- latte, frappe, macchiato, mocha
    transparent_background = true,
  })

  vim.cmd('colorscheme catppuccin')
  return
end

-- https://github.com/rebelot/kanagawa.nvim
if colorscheme == colorschemes.kanagawa then
  require('kanagawa').setup({
    transparent = true,
    theme = 'wave',
  })

  vim.cmd('colorscheme kanagawa')
  return
end
