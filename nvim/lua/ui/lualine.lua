-- https://github.com/nvim-lualine/lualine.nvim
local status_ok, lualine = pcall(require, 'lualine')

if not status_ok then
  vim.notify('lualine not found!')
  return
end

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
    lualine_b = { 'branch', { 'filename', separator = { right = '' } } },
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
