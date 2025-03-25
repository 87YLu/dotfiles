-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- ui
  require('ui.alpha'),
  require('ui.bufferline'),
  require('ui.colorscheme'),
  require('ui.indent-blankline'),
  require('ui.lualine'),
  require('ui.neo-tree'),
  require('ui.noice'),
  require('ui.nvim-ufo'),
  require('ui.nvim-colorizer'),
  -- enhance
  require('enhance.comment'),
  require('enhance.cutlass'),
  require('enhance.diffview'),
  require('enhance.faster'),
  require('enhance.flash'),
  require('enhance.gitsigns'),
  require('enhance.harpoon'),
  require('enhance.hbac'),
  require('enhance.nvim-autopairs'),
  require('enhance.nvim-surround'),
  require('enhance.persistence'),
  require('enhance.project'),
  require('enhance.telescope'),
  require('enhance.todo-comments'),
  require('enhance.toggleterm'),
  require('enhance.whick-key'),
  -- lsp
  require('lsp.cmp'),
  require('lsp.codeium'),
  require('lsp.conform'),
  require('lsp.lsp-config'),
  require('lsp.mason'),
  require('lsp.nvim-custom-diagnostic-highlight'),
  require('lsp.nvim-lint'),
  require('lsp.nvim-treesitter'),
  require('lsp.treesj'),
}

local opts = {
  git = {
    timeout = 600,
    -- url_format = "https://github.com/%s.git",
    url_format = 'git@github.com:%s.git',
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

require('lazy').setup(plugins, opts)
