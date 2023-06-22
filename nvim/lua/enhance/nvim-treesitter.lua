-- https://github.com/nvim-treesitter/nvim-treesitter
local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')

if not status_ok then
  vim.notify('nvim-treesitter not found!')
  return
end

treesitter.setup({
  -- 安装 language parser
  -- :TSInstallInfo 命令查看支持的语言
  ensure_installed = {
    'json',
    'html',
    'css',
    'vim',
    'lua',
    'javascript',
    'typescript',
    'tsx',
    'rust',
    'scss',
    'markdown',
    'markdown_inline',
    'yaml',
  },
  -- 启用代码高亮模块
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  -- 启用增量选择模块
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    },
  },
  rainbow = {
    enable = true,
    disable = { 'jsx' },
  },
})

-- 开启 Folding 模块
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- 默认不要折叠
vim.opt.foldenable = false
