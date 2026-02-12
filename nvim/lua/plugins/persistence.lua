local cwd = vim.loop.cwd()
local session_dir = Utils.Path.get_session_path()
local session_path = session_dir .. cwd:gsub('/', '%%') .. '.vim'
local is_current_in_home = (cwd == '') or (cwd == vim.loop.os_homedir())

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('PersistenceEnter', { clear = true }),
  callback = function()
    if is_current_in_home then
      require('persistence').stop()
      return
    end

    if Utils.Path.is_exist(session_path) then
      require('persistence').load()
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
  group = vim.api.nvim_create_augroup('PersistenceLeave', { clear = true }),
  callback = function()
    if is_current_in_home and Utils.Path.get_project_root() ~= cwd then
      vim.cmd(
        'mks! ' .. vim.fn.fnameescape(session_dir .. Utils.Path.get_project_root():gsub('[\\/:]+', '%%') .. '.vim')
      )
    end
  end,
  nested = true,
})

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    dir = session_dir,
    branch = false,
  },
  config = function(_, opts)
    require('persistence').setup(opts)
  end,
}
