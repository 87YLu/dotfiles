-- https://github.com/nvim-lualine/lualine.nvim
local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then
  vim.notify('lualine not found!')
  return
end

local input_mode = require('utils.input_mode')
local system = require('utils.system')

local function nav()
  local items = vim.b.coc_nav or {}
  local t = { '%#NonText#' .. '    ' }
  for k, v in ipairs(items) do
    t[#t + 1] = ' %#'
      .. (v.highlight or 'NormalNC')
      .. '#'
      .. (type(v.label) == 'string' and v.label .. ' ' or ' ')
      .. '%#Comment#'
      .. (v.name or '')
    if next(items, k) ~= nil then
      t[#t + 1] = '%#NonText# '
    end
  end

  return table.concat(t)
end

lualine.setup({
  options = {
    theme = vim.g.colorscheme == 'tokyonight' and 'tokyonight' or 'auto',
    component_separators = '|',
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha' },
      winbar = { 'neo-tree', 'alpha' },
      refresh = {
        statusline = 2000,
      },
    },
  },
  winbar = {
    lualine_a = { nav },
    lualine_b = { '%#NonText#' .. '' },
  },
  inactive_winbar = {
    lualine_a = { nav },
    lualine_b = { '%#NonText#' .. '' },
  },
  extensions = { 'neo-tree', 'toggleterm' },
  sections = {
    lualine_a = {
      { 'mode', separator = { right = '' }, right_padding = 2 },
    },
    lualine_b = {
      'branch',
      system.is_apple_silicon and input_mode.mode or nil,
      { 'filename', separator = { right = '' } },
    },
    lualine_c = { 'diagnostics' },
    lualine_x = {},
    lualine_y = {
      {
        'tabnine',
        separator = { left = '' },
      },
      'filetype',
      {
        'fileformat',
        symbols = {
          unix = 'LF',
          dos = 'CRLF',
          mac = 'CR',
        },
      },
      'encoding',
      'progress',
    },
    lualine_z = {
      'location',
    },
  },
})
