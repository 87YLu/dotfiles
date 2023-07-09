-- https://github.com/Bekaboo/dropbar.nvim
local status_ok, dropbar = pcall(require, 'dropbar')

if not status_ok then
  vim.notify('dropbar not found!')
  return
end

dropbar.setup()
