vim.cmd(':highlight CocInlayHint guifg=#4c4c4c gui=bold,italic,underline')
vim.cmd(':highlight CursorLineNr gui=italic,bold')

local transparent_background = vim.g.transparent_background
local current_colorscheme

-- https://github.com/catppuccin/nvim
local catppuccin = function()
  require('catppuccin').setup({
    flavour = 'macchiato', -- latte, frappe, macchiato, mocha
    transparent_background = transparent_background,
  })

  vim.opt.background = 'dark'
  vim.cmd('colorscheme catppuccin')
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
end

-- https://github.com/rebelot/kanagawa.nvim
local kanagawa = function()
  require('kanagawa').setup({
    transparent = transparent_background,
    theme = 'wave',
  })

  vim.opt.background = 'dark'
  vim.cmd('colorscheme kanagawa')
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
end

local tokyonight_day = function()
  require('tokyonight').setup({
    style = 'day',
    transparent = false,
  })

  vim.opt.background = 'light'
  vim.cmd('colorscheme tokyonight')
end

local colorscheme = {
  catppuccin = catppuccin,
  github = github,
  kanagawa = kanagawa,
  tokyonight = tokyonight,
  tokyonight_day = tokyonight_day,
}

local change_colorscheme = function(color)
  colorscheme[color]()
  current_colorscheme = color
end

change_colorscheme(vim.g.colorscheme)

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local state = require('telescope.actions.state')
local global_config_utils = require('utils.global-config')

local colorschemes = {
  'catppuccin',
  'github',
  'kanagawa',
  'tokyonight',
  'tokyonight_day',
}

function _G.open_colorscheme_switcher()
  change_colorscheme(colorschemes[1])

  local picker = pickers.new({
    results_title = 'Change Colorscheme',
    finder = finders.new_table({
      results = colorschemes,
    }),
    sorter = sorters.get_fzy_sorter(),
    layout_config = {
      height = 0.3,
      width = 0.3,
    },
    attach_mappings = function(prompt_bufnr, map)
      local down = function()
        actions.move_selection_next(prompt_bufnr)
        change_colorscheme(state.get_selected_entry().value)
      end

      local up = function()
        actions.move_selection_previous(prompt_bufnr)
        change_colorscheme(state.get_selected_entry().value)
      end

      local close = function()
        actions.close(prompt_bufnr)
        change_colorscheme(vim.g.colorscheme)
      end

      local select = function()
        local value = state.get_selected_entry().value
        actions.close(prompt_bufnr)
        global_config_utils.set_global_config('colorscheme', value)
      end

      map({ 'i', 'n' }, '<CR>', select)
      map({ 'i', 'n' }, '<Down>', down)
      map({ 'i', 'n' }, '<Tab>', down)
      map('i', '<C-n>', down)
      map({ 'i', 'n' }, '<Tab>', down)
      map({ 'i', 'n' }, '<Up>', up)
      map('i', '<C-p>', up)
      map('n', '<Esc>', close)
      map('i', '<C-c>', close)

      return true
    end,
  })

  picker:find()
end

function _G.open_transparent_background_switcher()
  local picker = pickers.new({
    results_title = 'Transparent Background',
    finder = finders.new_table({
      results = {
        'true',
        'false',
      },
    }),
    sorter = sorters.get_fzy_sorter(),
    layout_config = {
      height = 0.15,
      width = 0.3,
    },
    attach_mappings = function(prompt_bufnr, map)
      map({ 'i', 'n' }, '<CR>', function()
        local value = state.get_selected_entry().value
        actions.close(prompt_bufnr)
        global_config_utils.set_global_config('transparent_background', (value == 'true'))
        transparent_background = value == 'true'
        change_colorscheme(current_colorscheme)
      end)
      map({ 'i', 'n' }, '<Tab>', function()
        actions.move_selection_next(prompt_bufnr)
      end)
      return true
    end,
  })

  picker:find()
end
