-- https://github.com/williamboman/mason.nvim
return {
  'williamboman/mason.nvim',
  event = 'BufReadPost',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup({
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    })
    require('mason-lspconfig').setup({})
    require('mason-tool-installer').setup({
      -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
      ensure_installed = {
        -- lsp
        'lua-language-server',
        'rust-analyzer',
        'html-lsp',
        'css-lsp',
        'ts_ls',
        'json-lsp',
        'marksman',
        -- formatter
        'prettier',
        'stylua',
        'rustfmt',
        'shfmt',
        -- linter
        'cspell',
      },
    })
  end,
}
