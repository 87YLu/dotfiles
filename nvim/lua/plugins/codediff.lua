local codediff_saved = {}

vim.api.nvim_create_autocmd('User', {
  pattern = 'CodeDiffOpen',
  callback = function()
    codediff_saved.showtabline = vim.o.showtabline
    codediff_saved.laststatus = vim.o.laststatus
    vim.o.showtabline = 0

    vim.defer_fn(function()
      require('lualine').hide()
      vim.o.laststatus = codediff_saved.laststatus
    end, 50)
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'CodeDiffClose',
  callback = function()
    vim.o.showtabline = codediff_saved.showtabline or 2
    vim.o.laststatus = codediff_saved.laststatus or 3
    codediff_saved = {}

    vim.defer_fn(function()
      require('lualine').hide({ unhide = true })
    end, 50)
  end,
})

return {
  'esmuellert/codediff.nvim',
  event = 'LazyFile',
  cmd = 'CodeDiff',
  config = function()
    require('codediff').setup({
      explorer = {
        view_mode = 'tree',
      },
      keymaps = {
        explorer = {
          select = 'l',
        },
      },
    })

    vim.keymap.set(
      'n',
      PluginsKeyMapping.Codediff.openDiff.key,
      '<cmd>CodeDiff<cr>',
      { desc = PluginsKeyMapping.Codediff.openDiff.desc }
    )

    vim.keymap.set(
      'n',
      PluginsKeyMapping.Codediff.currentFileHistory.key,
      '<cmd>CodeDiff history %<cr>',
      { desc = PluginsKeyMapping.Codediff.currentFileHistory.desc }
    )

    vim.keymap.set(
      'n',
      PluginsKeyMapping.Codediff.projectFileHistory.key,
      '<cmd>CodeDiff history<cr>',
      { desc = PluginsKeyMapping.Codediff.projectFileHistory.desc }
    )
  end,
}
