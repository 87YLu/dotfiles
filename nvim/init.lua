local function plugin_setup()
  -- https://github.com/folke/lazy.nvim
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

  local common_plugins = require('common.basic.plugins')
  local native_plugins = require('native.basic.plugins')

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

  local plugins = common_plugins

  if not vim.g.vscode then
    for i = 1, #native_plugins do
      plugins[#plugins + 1] = native_plugins[i]
    end
  end

  require('lazy').setup(plugins, opts)
end

require('common.basic.configs')

plugin_setup()

require('common.basic.keymaps')

if not vim.g.vscode then
  local global_config = require('native.utils.global_config').get_global_config()

  if global_config ~= nil then
    for key, value in pairs(global_config) do
      vim.g[key] = value
    end
  end
  require('native.basic.autocmds')
end
