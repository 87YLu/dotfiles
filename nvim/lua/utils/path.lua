local M = {}

local project_root = {
  base = nil,
  root = nil,
}

M.get_git_root = function()
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

M.get_project_root = function()
  local current_file = vim.fn.expand('%:p')

  if current_file == '' then
    current_file = vim.fn.getcwd()
  end
  local base_dir = vim.fn.fnamemodify(current_file, ':h')

  if project_root.base == base_dir and project_root.root then
    return project_root.root
  end

  local git_root = M.get_git_root()

  if git_root then
    project_root.base = base_dir
    project_root.root = git_root
    return git_root
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

  project_root.base = base_dir
  project_root.root = find_root(base_dir)

  return project_root.root
end

M.get_current_path = function()
  return vim.api.nvim_buf_get_name(0)
end

M.get_pkg_path = function(pkg, path, opts)
  pcall(require, 'mason') -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ''
  local ret = vim.fs.normalize(root .. '/packages/' .. pkg .. '/' .. path)
  return ret
end

M.get_project_name = function()
  return vim.fn.fnamemodify(M.get_project_root(), ':t')
end

M.is_exist = function(path)
  local ok = vim.loop.fs_stat(path)
  return ok
end

M.get_session_path = function()
  return vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')
end

return M
