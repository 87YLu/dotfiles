-- https://github.com/numToStr/Comment.nvim
return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      -- 忽略空行
      ignore = '^$',
    })

    local keys = require('common.basic.keymaps').comment

    vim.g.keyset({ 'i', 'n' }, keys.toggle_line, function()
      require('Comment.api').toggle.linewise.current()
    end, { desc = 'toggle comment' })
    vim.g.keyset({ 'i', 'n' }, keys.toggle_block, function()
      require('Comment.api').toggle.blockwise.current()
    end, { desc = 'toggle comment' })
    vim.g.keyset('v', keys.toggle_line, '<Plug>(comment_toggle_linewise_visual)', { desc = 'toggle comment' })
  end,
}
