-- https://github.com/akinsho/bufferline.nvim
local status_ok, bufferline = pcall(require, 'bufferline')

if not status_ok then
  vim.notify('bufferline not found!')
  return
end

-- https://github.com/akinsho/bufferline.nvim#configuration
bufferline.setup({
  options = {
    -- 关闭 Tab 的命令，这里使用 moll/vim-bbye 的 :Bdelete 命令
    close_command = 'Bdelete! %d',
    right_mouse_command = 'Bdelete! %d',
    -- 侧边栏配置
    -- 左侧让出 nvim-tree 的位置，显示文字 File Explorer
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        text_align = 'left',
      },
    },
  },
})
