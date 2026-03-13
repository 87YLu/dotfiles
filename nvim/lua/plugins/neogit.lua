return {
  'NeogitOrg/neogit',
  event = 'LazyFile',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'folke/snacks.nvim',
  },
  cmd = 'Neogit',
  opts = {
    floating = {
      width = 0.9,
      height = 0.9,
      border = 'rounded',
    },
  },
  keys = {
    {
      PluginsKeyMapping.Neogit.open.key,
      function()
        require('neogit').open({ cwd = Utils.Path.get_git_root(), kind = 'floating' })
      end,
      desc = PluginsKeyMapping.Neogit.open.desc,
    },
  },
}
