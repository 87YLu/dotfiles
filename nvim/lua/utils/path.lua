local M = {}

local project_root = nil

function M.get_git_root()
  local current_file = vim.fn.expand('%:p')
  local current_dir

  if current_file == '' then
    current_dir = vim.fn.getcwd()
  else
    current_dir = vim.fn.expand('%:p:h')
  end

  local git_dir = vim.fn.finddir('.git', current_dir .. '/;')

  if git_dir == '' then
    return nil
  end

  local git_root = vim.fn.fnamemodify(git_dir, ':p:h:h')
  return git_root
end

function M.get_project_root()
  if project_root then
    return project_root
  end

  local git_root = M.get_git_root()

  if git_root then
    project_root = git_root
    return git_root
  end

  local current_file = vim.fn.expand('%:p')

  if current_file == '' then
    current_file = vim.fn.getcwd()
  end

  local markers = { 'package.json', '.project', 'Cargo.toml', 'pyproject.toml', 'Makefile' }

  local function find_root(path)
    if path == '' or path == '/' then
      return vim.fn.getcwd()
    end

    for _, marker in ipairs(markers) do
      if vim.fn.isdirectory(path .. '/' .. marker) == 1 or vim.fn.filereadable(path .. '/' .. marker) == 1 then
        return path
      end
    end

    return find_root(vim.fn.fnamemodify(path, ':h'))
  end

  project_root = find_root(vim.fn.fnamemodify(current_file, ':h'))

  return project_root
end

function M.get_current_path()
  return vim.api.nvim_buf_get_name(0)
end

function M.get_pkg_path(pkg, path, opts)
  pcall(require, 'mason') -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ''
  local ret = vim.fs.normalize(root .. '/packages/' .. pkg .. '/' .. path)
  if opts.warn then
    vim.schedule(function()
      if not require('lazy.core.config').headless() and not vim.loop.fs_stat(ret) then
        vim.notify(pkg .. ' not found')
      end
    end)
  end
  return ret
end

function M.is_exist(path)
  local ok = vim.loop.fs_stat(path)
  return ok
end

return M

