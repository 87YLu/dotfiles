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
    'bash',
  },
  -- 启用代码高亮模块
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  -- 启用增量选择模块
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
    },
  },
  context_commentstring = {
    enable = true,
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
})

-- https://github.com/hiphish/rainbow-delimiters.nvim
local status_ok, rainbow_delimiters = pcall(require, 'rainbow-delimiters')

if not status_ok then
  vim.notify('rainbow_delimiters not found!')
  return
end

vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}
