-- https://github.com/folke/tokyonight.nvim
local colorschemes = vim.g.colorschemes
local colorscheme = vim.g.colorscheme

if colorscheme == colorschemes.tokyonight then
  require('tokyonight').setup({
    style = 'night',
    transparent = true,
    on_colors = function(colors)
      colors.comment = '#737881'
      colors.bg_visual = '#3a4150'
    end,
  })

  -- background_colour must be specified if transparent is true.
  require('notify').setup({
    background_colour = '#414868',
  })

  vim.cmd('colorscheme tokyonight')
  return
end

-- https://github.com/dracula/vim
if colorscheme == colorschemes.dracula then
  vim.g.dracula_colorterm = 0
  vim.cmd('colorscheme dracula')
  return
end

-- https://github.com/olimorris/onedarkpro.nvim
if colorscheme == colorschemes.onedarkpro then
  require('onedarkpro').setup({
    options = {
      transparency = true,
    },
  })
  vim.cmd('colorscheme onedark')
  return
end
