-- https://github.com/terrortylor/nvim-comment
local status_ok, nvim_comment = pcall(require, 'nvim_comment')

if not status_ok then
  vim.notify('nvim_comment not found!')
  return
end

nvim_comment.setup({
  create_mappings = false,
  comment_empty = false,
  comment_empty_trim_whitespace = true,
})
