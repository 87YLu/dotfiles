-- https://github.com/Wansmer/treesj
return {
  'Wansmer/treesj',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'VeryLazy',
  config = function()
    local treesj = require('treesj')
    local keys = require('common.basic.keymaps').treesj

    treesj.setup({
      use_default_keymaps = false,
      max_join_length = 1000,
    })

    vim.g.keyset('n', keys.toggle, treesj.toggle)
  end,
}
