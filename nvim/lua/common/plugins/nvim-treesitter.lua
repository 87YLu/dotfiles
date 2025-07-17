-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPost',
  build = ':TSUpdate',
  dependencies = vim.g.vscode and {} or {
    'hiphish/rainbow-delimiters.nvim',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'windwp/nvim-ts-autotag',
  },
  config = function()
    local treesitter = require('nvim-treesitter.configs')

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
        'vimdoc',
      },
      -- 启用代码高亮模块
      highlight = vim.g.vscode and { enable = false } or {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          if string.find(table.concat({ 'json', 'vim', 'yaml', 'bash', 'vimdoc' }, ''), lang) ~= nil then
            return true
          end

          local max_filesize = 15 * 1024 -- 15 KB
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
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })

    if not vim.g.vscode then
      local rainbow_delimiters = require('rainbow-delimiters')

      require('ts_context_commentstring').setup({})

      vim.treesitter.language.register('html', 'ttml')

      -- https://github.com/hiphish/rainbow-delimiters.nvim
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
    end
  end,
}
