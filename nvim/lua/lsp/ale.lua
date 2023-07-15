-- https://github.com/dense-analysis/ale
local format_config = '~/.config/nvim/lua/lsp/format-configs/'
local global_prettier_config = format_config .. '/.prettierrc'
local stylua_config = format_config .. 'stylua.toml'

local set_perttier_config = function()
  local prettier_type = 'javascript'
    .. 'javascriptreact'
    .. 'typescript'
    .. 'typescriptreact'
    .. 'css'
    .. 'less'
    .. 'html'
    .. 'json'
    .. 'yaml'

  local is_prettier_type = string.find(prettier_type, vim.o.filetype) ~= nil

  if not is_prettier_type then
    return
  end

  local package_json = vim.fn.getcwd() .. '/package.json'

  local success, result = pcall(function()
    for line in io.lines(package_json) do
      if string.find(line, '"prettier"') ~= nil then
        return true
      end
    end
    return false
  end)

  vim.g.ale_javascript_prettier_options = success and result and '' or '--config ' .. global_prettier_config
end

vim.g.ale_before_fix = function()
  set_perttier_config()
end

vim.api.nvim_exec(
  [[
    augroup prettier
      autocmd!
      autocmd User ALEFixPre call ale_before_fix()
    augroup END
  ]],
  true
)

vim.g.ale_after_fix = function()
  vim.cmd('Noice dismiss')
end

vim.api.nvim_exec(
  [[
    augroup slient
      autocmd!
      autocmd User ALEFixPost call ale_after_fix()
    augroup END
  ]],
  true
)

vim.g.ale_fix_on_save = 1

vim.g.ale_disable_lsp = 1

vim.g.ale_use_neovim_diagnostics_api = 1

vim.g.ale_echo_cursor = 0

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
})

local signs = { Error = '', Warn = '', Hint = '󰌶', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.g.ale_fixers = {
  javascript = 'prettier',
  javascriptreact = 'prettier',
  typescript = 'prettier',
  typescriptreact = 'prettier',
  css = 'prettier',
  less = 'prettier',
  html = 'prettier',
  json = 'prettier',
  yaml = 'prettier',
  lua = 'stylua',
  rust = 'rustfmt',
  sh = 'shfmt',
  ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
}

vim.g.ale_lua_stylua_options = '--config-path ' .. stylua_config
