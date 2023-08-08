-- https://github.com/numToStr/Comment.nvim
local status_ok, Comment = pcall(require, 'Comment')

if not status_ok then
  vim.notify('Comment not found!')
  return
end

Comment.setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
