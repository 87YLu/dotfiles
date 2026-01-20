_G.Utils = require('utils')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local Event = require('lazy.core.handler.event')
Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' } }
Event.mappings['User LazyFile'] = Event.mappings.LazyFile

_G.Icons = {
  misc = {
    dots = '󰇘',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Codeium = '󰘦 ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = '󱄽 ',
    String = ' ',
    Struct = '󰆼 ',
    Supermaven = ' ',
    TabNine = '󰏚 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}

_G.VirtualText = {
  spacing = 4,
  source = 'always',
  prefix = '●',
}

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    require('plugins.coding.conform'),
    require('plugins.bufferline'),
    require('plugins.colorscheme'),
    require('plugins.cutlass'),
    require('plugins.flash'),
    require('plugins.snacks'),

    not vim.g.vscode and {
      require('plugins.coding.cmp'),
      require('plugins.coding.lsp'),
      require('plugins.coding.mini-pairs'),
      require('plugins.coding.todo-comment'),
      require('plugins.coding.treesitter'),
      require('plugins.gitsigns'),
      require('plugins.lualine'),
      require('plugins.noice'),
      require('plugins.grug-far'),
      require('plugins.harpoon'),
      require('plugins.nvim-tree'),
      require('plugins.persistence'),
      require('plugins.smear-cursor'),
      require('plugins.whick-key'),
    } or {},
  },
  install = { colorscheme = { 'habamax' } },
  ui = {
    border = 'rounded',
  },
})
