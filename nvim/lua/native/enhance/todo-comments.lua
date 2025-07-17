-- https://github.com/folke/todo-comments.nvim
return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('todo-comments').setup({
      merge_keywords = false,
      keywords = {
        NOTE = { icon = ' ', color = '#10B981', alt = { 'INFO' } },
        TODO = { icon = ' ', color = '#FBBF24' },
        HACK = { icon = ' ', color = '#FBBF24' },
        FIX = { icon = ' ', color = '#FF2D00', alt = { 'BUG' } },
        WARN = { icon = ' ', color = '#FF2D00', alt = { 'WARNING' } },
      },
    })
  end,
}
