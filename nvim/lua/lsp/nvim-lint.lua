-- https://github.com/mfussenegger/nvim-lint
local file = require('utils.file')
return {
  'mfussenegger/nvim-lint',
  event = 'VeryLazy',
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      html = { 'cspell' },
      css = { 'cspell' },
      less = { 'cspell' },
      javascript = { 'cspell' },
      javascriptreact = { 'cspell' },
      typescript = { 'cspell' },
      typescriptreact = { 'cspell' },
      lua = { 'cspell' },
      rust = { 'cspell' },
    }

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
