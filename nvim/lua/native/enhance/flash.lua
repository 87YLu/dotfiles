-- https://github.com/folke/flash.nvim
-- 光标跳转
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      '<space>s',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
  },
}
