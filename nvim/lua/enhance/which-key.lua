-- https://github.com/folke/which-key.nvim
local status_ok, whichkey = pcall(require, 'which-key')

if not status_ok then
  vim.notify('which-key not found!')
  return
end

whichkey.setup()
