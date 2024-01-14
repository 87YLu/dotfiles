-- https://github.com/Wansmer/treesj
return {
  'Wansmer/treesj',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'VeryLazy',
  config = function()
    local treesj = require('treesj')
    treesj.setup({
      use_default_keymaps = false,
      max_join_length = 1000,
    })

    require('basic.keymaps').treesj(treesj.toggle)
  end,
}
