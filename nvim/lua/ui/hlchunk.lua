-- https://github.com/shellRaining/hlchunk.nvim
local status_ok, hlchunk = pcall(require, 'hlchunk')

if not status_ok then
  vim.notify('hlchunk not found!')
  return
end

hlchunk.setup({
  chunk = {
    enable = true,
    use_treesitter = true,
    chars = {
      horizontal_line = '⌲',
      vertical_line = '│',
      left_top = '╭',
      left_bottom = '╰',
      right_arrow = '⌲',
    },
  },
  indent = {
    chars = { '│', '¦', '┆', '┊' },
    use_treesitter = true,
  },
  blank = {
    enable = false,
  },
  line_num = {
    enable = false,
  },
})
