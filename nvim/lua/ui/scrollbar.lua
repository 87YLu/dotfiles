-- https://github.com/petertriho/nvim-scrollbar
local status_ok, scrollbar = pcall(require, 'scrollbar')

if not status_ok then
  vim.notify('scrollbar not found!')
  return
end

scrollbar.setup({
  show = true,
  handle = {
    color = '#b390f2',
  },
  excluded_filetypes = {
    'neo-tree',
    'coctree'
  },
})
