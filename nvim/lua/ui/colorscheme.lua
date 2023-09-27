vim.cmd(':highlight CocInlayHint guifg=#4c4c4c gui=bold,italic,underline')
vim.cmd(':highlight CursorLineNr gui=italic,bold')

-- https://github.com/catppuccin/nvim
local catppuccin = function()
  require('catppuccin').setup({
    flavour = 'macchiato', -- latte, frappe, macchiato, mocha
    transparent_background = true,
  })

  vim.cmd('colorscheme catppuccin')
end

-- https://github.com/rebelot/kanagawa.nvim
local kanagawa = function()
  require('kanagawa').setup({
    transparent = true,
    theme = 'wave',
  })

  vim.cmd('colorscheme kanagawa')
end

-- https://github.com/folke/tokyonight.nvim
local tokyonight = function()
  require('tokyonight').setup({
    style = 'night',
    transparent = true,
    styles = {
      sidebars = 'transparent',
      floats = 'transparent',
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

  vim.cmd('colorscheme tokyonight')
end

local colorscheme = {
  catppuccin = catppuccin,
  kanagawa = kanagawa,
  tokyonight = tokyonight,
}

colorscheme[vim.g.colorscheme]()

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local state = require('telescope.actions.state')
local global_config_utils = require('utils.global-config')

local colorschemes = {
  'catppuccin',
  'kanagawa',
  'tokyonight',
}

function _G.open_colorscheme_switcher()
  colorscheme[colorschemes[1]]()

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
        colorscheme[state.get_selected_entry().value]()
      end

      local up = function()
        actions.move_selection_previous(prompt_bufnr)
        colorscheme[state.get_selected_entry().value]()
      end

      local close = function()
        actions.close(prompt_bufnr)
        colorscheme[vim.g.colorscheme]()
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
