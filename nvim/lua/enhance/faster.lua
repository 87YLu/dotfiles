-- 优化大文件体验

local max_file_size = 1024 * 1024 * 1 -- 1 MB

local call_cmp_when_exist = function(cmd)
  if vim.fn.exists(':' .. cmd) ~= 2 then
    return
  end
  vim.cmd(cmd)
end

local faster = {}

-- treesitter
faster.treesitter = {
  backup = {},
  disabled = false,
  enable = function()
    local status_ok, _ = pcall(require, 'nvim-treesitter.configs')
    if not status_ok then
      return
    end

    if vim.fn.exists(':TSEnable') ~= 2 then
      return
    end

    if faster.treesitter.disabled == true then
      -- Return treesitter module state from backup
      for _, mod_state in ipairs(faster.treesitter.backup) do
        if mod_state.enable then
          vim.cmd('TSEnable ' .. mod_state.mod_name)
        end
      end
      faster.treesitter.disabled = false
    end
  end,

  disable = function()
    local status_ok, ts_config = pcall(require, 'nvim-treesitter.configs')
    if not status_ok then
      return
    end

    if vim.fn.exists(':TSDisable') ~= 2 then
      return
    end

    if faster.treesitter.disabled == false then
      for _, mod_name in ipairs(ts_config.available_modules()) do
        local module_config = ts_config.get_module(mod_name) or {}
        table.insert(faster.treesitter.backup, { mod_name = mod_name, enable = module_config.enable })
      end
      faster.treesitter.disabled = true
    end

    for _, mod_name in ipairs(ts_config.available_modules()) do
      vim.cmd('TSDisable ' .. mod_name)
    end
  end,
}

-- vimopts
faster.vimopts = {
  backup = {},
  disabled = false,
  enable = function()
    if faster.vimopts.disabled == true then
      vim.opt_local.swapfile = faster.vimopts.backup.swapfile
      vim.opt_local.foldmethod = faster.vimopts.backup.foldmethod
      vim.opt_local.undolevels = faster.vimopts.backup.undolevels
      vim.opt_local.undoreload = faster.vimopts.backup.undoreload
      vim.opt_local.list = faster.vimopts.backup.list
      faster.vimopts.disabled = false
    end
  end,
  disable = function()
    if faster.vimopts.disabled == false then
      faster.vimopts.backup.swapfile = vim.opt_local.swapfile
      faster.vimopts.backup.foldmethod = vim.opt_local.foldmethod
      faster.vimopts.backup.undolevels = vim.opt_local.undolevels
      faster.vimopts.backup.undoreload = vim.opt_local.undoreload
      faster.vimopts.backup.list = vim.opt_local.list
      faster.vimopts.disabled = true
    end

    vim.opt_local.swapfile = false
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.undolevels = -1
    vim.opt_local.undoreload = 0
    vim.opt_local.list = false
  end,
}

-- codeium
faster.codeium = {
  enable = function()
    call_cmp_when_exist('CodeiumEnable')
  end,
  disable = function()
    call_cmp_when_exist('CodeiumDisable')
  end,
}

-- cmp
faster.cmp = {
  enable = function()
    require('cmp').setup.buffer({
      enabled = true,
    })
  end,
  disable = function()
    require('cmp').setup.buffer({
      enabled = false,
    })
  end,
}

-- syntax
faster.syntax = {
  backup = {},
  disabled = false,
  enable = function()
    if faster.syntax.disabled == true then
      vim.opt_local.syntax = faster.syntax.backup.syntax
      faster.syntax.disabled = false
    end
  end,
  disable = function()
    if faster.syntax.disabled == false then
      faster.syntax.backup.syntax = vim.opt_local.syntax
      faster.syntax.disabled = true
    end
    vim.cmd('syntax clear')
    vim.opt_local.syntax = 'off'
  end,
}

-- filetype
faster.filetype = {
  backup = {},
  disabled = false,
  enable = function()
    if faster.filetype.disabled == true then
      vim.opt_local.filetype = faster.filetype.backup.filetype
      faster.filetype.disabled = false
    end
  end,
  disable = function()
    if faster.filetype.disabled == false then
      faster.filetype.backup.filetype = vim.opt_local.filetype
      faster.filetype.disabled = true
    end
    vim.opt_local.filetype = ''
  end,
}

local faster_disabled = function()
  -- faster.vimopts.disable()
  faster.codeium.disable()
  faster.treesitter.disable()
  faster.cmp.disable()
  faster.syntax.disable()
  faster.filetype.disable()
end

local faster_enabled = function()
  -- faster.vimopts.enable()
  faster.codeium.enable()
  faster.treesitter.enable()
  faster.cmp.enable()
  faster.syntax.enable()
  faster.filetype.enable()
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufReadPre' }, {
  callback = function()
    local file_name = vim.api.nvim_buf_get_name(0)
    if vim.loop.fs_stat(file_name) then
      local file_size = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0)).size
      if file_size > max_file_size then
        faster_disabled()
      else
        faster_enabled()
      end
    end
  end,
})

return {}
