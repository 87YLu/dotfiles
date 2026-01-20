local cwd = vim.loop.cwd()
local session_dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')
local session_path = session_dir .. cwd:gsub('/', '%%') .. '.vim'

local disabled_dirs = {
  vim.loop.os_homedir(),
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

    if Utils.Path.is_exist(session_path) then
      require('persistence').load()

      if Utils.NvimConfig.get('nvim_tree_visible', false) then
        local api = require('nvim-tree.api')
        api.tree.toggle({ path = Utils.Path.get_project_root(), focus = false })
      end
    end
  end,
  nested = true,
})

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    dir = session_dir,
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    pre_save = nil,
    save_empty = false,
    branch = false,
  },
  config = function(_, opts)
    require('persistence').setup(opts)
  end,
}
