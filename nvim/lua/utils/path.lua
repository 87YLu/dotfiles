---@class UtilsPath
local M = {}

---@class UtilsPathProjectRootCache
---@field base? string
---@field root? string
local project_root = {
  base = nil,
  root = nil,
}

---@return string|nil
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

---@return string
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

  ---@param path string
  ---@return string
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

---@return string
M.get_current_path = function()
  return vim.api.nvim_buf_get_name(0)
end

---@param pkg string
---@param path? string
---@param _opts? { warn?: boolean }
---@return string
M.get_pkg_path = function(pkg, path, _opts)
  pcall(require, 'mason') -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  path = path or ''
  local ret = vim.fs.normalize(root .. '/packages/' .. pkg .. '/' .. path)
  return ret
end

---@return string
M.get_project_name = function()
  return vim.fn.fnamemodify(M.get_project_root(), ':t')
end

---@param path string
---@return boolean
M.is_exist = function(path)
  local ok = vim.loop.fs_stat(path)
  return ok ~= nil
end

---@return string
M.get_session_path = function()
  return vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')
end

return M
