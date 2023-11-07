-- https://github.com/stevearc/conform.nvim
local format_config = vim.loop.os_homedir() .. '/.config/nvim/lua/lsp/format-configs/'
local global_prettier_config = format_config .. '.prettierrc'
local stylua_config = format_config .. 'stylua.toml'
local utils = require('utils')

local package_json = utils.cwd() .. '/package.json'

local success, result = pcall(function()
  for line in io.lines(package_json) do
    if string.find(line, '"prettier"') ~= nil then
      return true
    end
  end
  return false
end)

require('conform').setup({
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
    ['*'] = { 'codespell' },
    ['_'] = { 'trim_whitespace' },
  },
  formatters = {
    prettier = {
      command = 'prettier',
      prepend_args = success and result and {} or { '--config', global_prettier_config },
    },
    stylua = {
      command = 'stylua',
      prepend_args = { '--config-path', stylua_config },
    },
  },
})
