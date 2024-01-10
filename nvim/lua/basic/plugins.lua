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

local ui = {
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
      require('ui.alpha')
    end,
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'moll/vim-bbye',
    event = 'VeryLazy',
    config = function()
      require('ui.bufferline')
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = vim.g.colorscheme ~= 'catppuccin',
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = vim.g.colorscheme ~= 'github',
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = vim.g.colorscheme ~= 'kanagawa',
  },
  {
    'folke/tokyonight.nvim',
    lazy = vim.g.colorscheme ~= 'tokyonight' and vim.g.colorscheme ~= 'tokyonight_day',
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function()
      require('ui.indent-blankline')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('ui.lualine')
    end,
  },
  {
    'echasnovski/mini.indentscope',
    event = 'VeryLazy',
    version = '*',
    config = function()
      require('ui.mini-indentscope')
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    config = function()
      require('ui.neo-tree')
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('ui.noice')
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    config = function()
      require('ui.nvim-ufo')
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    event = 'VeryLazy',
    config = function()
      require('ui.scrollbar')
    end,
  },
}

local enhance = {
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = function()
      require('enhance.comment')
    end,
  },
  {
    'gbprod/cutlass.nvim',
    event = 'VimEnter',
    opts = {
      cut_key = 'x',
    },
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    config = function()
      require('enhance.diffview')
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        '<space>s',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
    },
  },
  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('enhance.harpoon')
    end,
  },
  {
    'axkirillov/hbac.nvim',
    event = 'VeryLazy',
    config = function()
      require('enhance.hbac')
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('enhance.nvim-autopairs')
    end,
  },
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('enhance.nvim-surround')
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    config = function()
      require('enhance.project')
    end,
  },
  {
    'Shatur/neovim-session-manager',
    event = 'VimEnter',
    config = function()
      require('enhance.session-manager')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-telescope/telescope-ui-select.nvim',
      'fannheyward/telescope-coc.nvim',
    },
    config = function()
      require('enhance.telescope')
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('enhance.todo-comments')
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    config = function()
      require('enhance.toggleterm')
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = true,
  },
}

local lsp = {
  {
    'neoclide/coc.nvim',
    event = 'VeryLazy',
    branch = 'release',
    config = function()
      require('lsp.coc')
    end,
  },
  {
    'stevearc/conform.nvim',
    event = 'VeryLazy',
    config = function()
      require('lsp.conform')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    build = ':TSUpdate',
    dependencies = {
      'hiphish/rainbow-delimiters.nvim',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      require('lsp.nvim-treesitter')
    end,
  },
  {
    'codota/tabnine-nvim',
    build = './dl_binaries.sh',
    event = 'VeryLazy',
    config = function()
      require('lsp.tabnine')
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      require('lsp.treesj')
    end,
  },
}

local plugins = {}

for _, i in ipairs({ ui, enhance, lsp }) do
  for _, plugin in ipairs(i) do
    table.insert(plugins, plugin)
  end
end

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
