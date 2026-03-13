return {
  'sindrets/diffview.nvim',
  event = 'LazyFile',
  config = function()
    require('diffview').setup({
      hooks = {
        diff_buf_win_enter = function()
          vim.opt_local.foldenable = false
        end,
      },
    })

    vim.keymap.set(
      'n',
      PluginsKeyMapping.DiffView.openDiff.key,
      '<cmd>DiffviewOpen<cr>',
      { desc = PluginsKeyMapping.DiffView.openDiff.desc }
    )

    vim.keymap.set(
      'n',
      PluginsKeyMapping.DiffView.currentFileHistory.key,
      '<cmd>DiffviewFileHistory %<cr>',
      { desc = PluginsKeyMapping.DiffView.currentFileHistory.desc }
    )

    vim.keymap.set(
      'n',
      PluginsKeyMapping.DiffView.projectFileHistory.key,
      '<cmd>DiffviewFileHistory<cr>',
      { desc = PluginsKeyMapping.DiffView.projectFileHistory.desc }
    )
  end,
}
