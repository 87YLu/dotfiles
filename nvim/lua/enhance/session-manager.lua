-- https://github.com/Shatur/neovim-session-manager
local status_ok, Path = pcall(require, 'plenary.path')

if not status_ok then
  vim.notify('plenary not found!')
  return
end

local status_ok, session_manager = pcall(require, 'session_manager')

if not status_ok then
  vim.notify('session_manager not found!')
  return
end

session_manager.setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
  path_replacer = '__',
  colon_replacer = '++',
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
  autosave_last_session = true,
  autosave_ignore_not_normal = true,
  autosave_ignore_filetypes = {
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_dirs = { '~' },
  autosave_only_in_session = false,
  max_path_length = 80,
})

vim.cmd([[
  augroup open_nvim_tree
    autocmd! * <buffer>
    autocmd SessionLoadPost * silent! :NvimTreeOpen
  augroup end
]])
