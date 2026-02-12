local formatter = {
  'prettier',
  'stylua',
  'rustfmt',
  'shfmt',
}

return {
  'stevearc/conform.nvim',
  event = 'LazyFile',
  dependencies = {
    'mason.nvim',
    { 'mason-org/mason-lspconfig.nvim', config = function() end },
  },
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      less = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      ['_'] = { 'trim_whitespace' },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
      prettier = {
        command = 'prettier',
      },
      stylua = {
        command = 'stylua',
      },
      rustfmt = {
        command = vim.fn.expand('~') .. '/.cargo/bin/rustfmt',
      },
    },
  },
  config = function(_, opts)
    local conform = require('conform')
    local mr = require('mason-registry')

    conform.setup(opts)

    for _, tool in ipairs(formatter) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end

    vim.keymap.set(
      'n',
      PluginsKeyMapping.Conform.format.key,
      conform.format,
      { desc = PluginsKeyMapping.Conform.format.desc }
    )
  end,
}

