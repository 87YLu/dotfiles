-- https://github.com/nvim-lualine/lualine.nvim
local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then
  vim.notify('lualine not found!')
  return
end

lualine.setup({
  options = {
    theme = 'tokyonight',
    component_separators = { left = '|', right = '|' },
    -- https://github.com/ryanoasis/powerline-extra-symbols
    section_separators = { left = ' ', right = '' },
  },
  extensions = { 'nvim-tree', 'toggleterm' },
  sections = {
    lualine_c = {
      'filename',
    },
    lualine_x = {
      'filesize',
      {
        'fileformat',
        symbols = {
          unix = 'LF',
          dos = 'CRLF',
          mac = 'CR',
        },
      },
      'encoding',
      'filetype',
    },
  },
})
