-- https://github.com/folke/persistence.nvim
local common_utils = require('native.utils.common')
local file_utils = require('native.utils.file')

local cwd = common_utils.cwd()
local home_dir = common_utils.homedir()
local session_dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')

local session_path = session_dir .. cwd:gsub('/', '%%') .. '.vim'

local disabled_dirs = {
  home_dir,
}

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('Persistence', { clear = true }),
  callback = function()
    for _, path in pairs(disabled_dirs) do
      if path == cwd then
        require('persistence').stop()
        return
      end
    end

    if file_utils.is_exist(session_path) then
      vim.g.session_exist = true
      require('persistence').load()
      if vim.g.neo_tree_open_status then
        local has_neotree, neotree = pcall(require, 'neo-tree.command')
        if has_neotree then
          neotree.execute({
            source = vim.g.neo_tree_source or 'filetype',
            action = 'show',
            reveal = true,
            reveal_force_cwd = true,
          })
        end
      end
    end
  end,
  nested = true,
})

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  config = function()
    local persistence = require('persistence')
    persistence.setup({
      dir = session_dir,
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      pre_save = nil,
      save_empty = false,
    })
  end,
}
