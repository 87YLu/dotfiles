-- https://github.com/lewis6991/gitsigns.nvim
local status_ok, gitsigns = pcall(require, 'gitsigns')

if not status_ok then
  vim.notify('gitsigns not found!')
  return
end

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.*',
  once = true,
  callback = function()
    gitsigns.setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
    })
  end,
})
