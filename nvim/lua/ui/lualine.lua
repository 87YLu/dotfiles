-- https://github.com/nvim-lualine/lualine.nvim
local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then
  vim.notify('lualine not found!')
  return
end

lualine.setup({
  options = {
    theme = vim.g.colorscheme,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  extensions = { 'neo-tree', 'toggleterm' },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'branch', 'filename' },
    lualine_c = { 'diagnostics' },
    lualine_x = {},
    lualine_y = {
      'tabnine',
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
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
})
