-- https://github.com/akinsho/bufferline.nvim
local status_ok, bufferline = pcall(require, 'bufferline')

if not status_ok then
  vim.notify('bufferline not found!')
  return
end

-- https://github.com/akinsho/bufferline.nvim#configuration
bufferline.setup({
  options = {
    -- from moll/vim-bbye
    close_command = 'Bdelete! %d',
    right_mouse_command = 'Bdelete! %d',
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'NeoTree',
        highlight = 'Directory',
        text_align = 'center',
      },
    },
  },
})
