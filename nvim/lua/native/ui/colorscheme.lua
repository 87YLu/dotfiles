local global_config_utils = require('native.utils.global_config')
local transparent_background = vim.g.transparent_background
local current_colorscheme = vim.g.colorscheme

-- https://github.com/catppuccin/nvim
local catppuccin = function()
  require('catppuccin').setup({
    flavour = 'macchiato', -- latte, frappe, macchiato, mocha
    transparent_background = transparent_background,
  })

  vim.opt.background = 'dark'
  vim.cmd('colorscheme catppuccin')
  vim.cmd(':highlight LuaLineLspColor guifg=#ffffff')
end

-- https://github.com/projekt0n/github-nvim-theme
local github = function()
  require('github-theme').setup({
    options = {
      transparent = transparent_background,
    },
  })

  vim.opt.background = 'dark'
  vim.cmd('colorscheme github_dark')
  vim.cmd(':highlight LuaLineLspColor guifg=#ffffff')
end

-- https://github.com/folke/tokyonight.nvim
local tokyonight = function()
  require('tokyonight').setup({
    style = 'night',
    transparent = transparent_background,
    styles = {
      sidebars = transparent_background and 'transparent' or 'dark',
      floats = transparent_background and 'transparent' or 'dark',
    },
    on_colors = function(colors)
      colors.comment = '#737881'
      colors.bg_visual = '#303F9F'
    end,
  })

  -- background_colour must be specified if transparent is true.
  require('notify').setup({
    background_colour = '#414868',
  })

  vim.opt.background = 'dark'
  vim.cmd('colorscheme tokyonight')
  vim.cmd(':highlight LuaLineLspColor guifg=#ffffff')
end

local tokyonight_day = function()
  require('tokyonight').setup({
    style = 'day',
    transparent = false,
  })

  vim.opt.background = 'light'
  vim.cmd('colorscheme tokyonight')
  vim.cmd(':highlight LuaLineLspColor guifg=#000000')
end

local colorscheme = {
  catppuccin = catppuccin,
  github = github,
  tokyonight = tokyonight,
  tokyonight_day = tokyonight_day,
}

local extractKeys = function(obj, specificKey)
  local keys = {}
  for key, _ in pairs(obj) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return a < b
  end)

  local specificIndex
  for i, key in ipairs(keys) do
    if key == specificKey then
      specificIndex = i
      break
    end
  end

  if specificIndex then
    table.remove(keys, specificIndex)
    table.insert(keys, 1, specificKey)
  end

  return keys
end

local change_colorscheme = function(color)
  current_colorscheme = color
  vim.g.colorscheme = color
  colorscheme[color]()
end

local handle_change_colorscheme = function()
  require('native.utils.telescope').telescope_select({
    title = 'Change Colorscheme',
    prefix = ' ',
    items = extractKeys(colorscheme, vim.g.colorscheme),
    handleMove = change_colorscheme,
    handleClose = function()
      change_colorscheme(vim.g.colorscheme)
    end,
    handleSelect = function(value)
      global_config_utils.set_global_config('colorscheme', value)
    end,
  })
end

local change_transparency = function()
  require('native.utils.telescope').telescope_select({
    title = 'Transparent Background',
    prefix = '  ',
    items = { 'true', 'false' },
    handleSelect = function(value)
      global_config_utils.set_global_config('transparent_background', (value == 'true'))
      transparent_background = value == 'true'
      change_colorscheme(current_colorscheme)
    end,
  })
end

local config = function()
  colorscheme[current_colorscheme]()
  local keys = require('native.basic.keymaps').colorscheme
  vim.g.keyset('n', keys.change_colorscheme, handle_change_colorscheme, { desc = 'change colorscheme' })
  vim.g.keyset('n', keys.change_transparency, change_transparency, { desc = 'change the background transparency' })
end

local get_lazy = function(colorscheme)
  return vim.g.colorscheme ~= colorscheme
end

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = get_lazy('catppuccin'),
    config = config,
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = get_lazy('github'),
    config = config,
  },
  {
    'folke/tokyonight.nvim',
    lazy = get_lazy('tokyonight') and get_lazy('tokyonight_day'),
    config = config,
  },
}
