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
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'goolord/alpha-nvim',
    config = function()
      require('ui.alpha')
    end,
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'moll/vim-bbye',
    config = function()
      require('ui.bufferline')
    end,
  },
  {
    'folke/tokyonight.nvim',
    config = function()
      require('ui.colorscheme')
    end,
  },
  {
    'shellRaining/hlchunk.nvim',
    config = function()
      require('ui.hlchunk')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('ui.lualine')
    end,
  },
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('ui.noice')
    end,
  },
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('ui.nvim-tree')
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('ui.scrollbar')
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  -- enhance
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  {
    'rhysd/accelerated-jk',
    config = function()
      vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)')
      vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)')
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('enhance.comment')
    end,
  },
  {
    'gbprod/cutlass.nvim',
    opts = {
      cut_key = 'x',
    },
  },
  {
    'sindrets/diffview.nvim',
    config = function()
      require('enhance.diffview')
    end,
  },
  {
    'Bekaboo/dropbar.nvim',
    config = true,
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
    'lewis6991/gitsigns.nvim',
    config = function()
      require('enhance.gitsigns')
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
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'hiphish/rainbow-delimiters.nvim',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('enhance.nvim-treesitter')
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('enhance.project')
    end,
  },
  {
    'Shatur/neovim-session-manager',
    config = function()
      require('enhance.session-manager')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('enhance.telescope')
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('enhance.toggleterm')
    end,
  },
  {
    'folke/which-key.nvim',
    config = true,
  },
  -- lsp
  {
    'dense-analysis/ale',
    config = function()
      require('lsp.ale')
    end,
  },
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      require('lsp.coc')
    end,
  },
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
