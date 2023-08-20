-- https://github.com/folke/todo-comments.nvim
local todo_comments = require('todo-comments')

todo_comments.setup({
  merge_keywords = false,
  keywords = {
    NOTE = { icon = ' ', color = '#10B981', alt = { 'INFO' } },
    TODO = { icon = ' ', color = '#FBBF24' },
    HACK = { icon = ' ', color = '#FBBF24' },
    FIX = { icon = ' ', color = '#FF2D00', alt = { 'BUG' } },
    WARN = { icon = ' ', color = '#FF2D00', alt = { 'WARNING' } },
  },
})
