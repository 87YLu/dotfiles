local M = {}
local file = {}
local current_file = {}

M.cwd = function()
  return vim.loop.cwd()
end

M.session_exist = function()
  if require('session_manager.config').dir_to_session_filename(M.cwd()):exists() then
    return true
  end

  return false
end

-- file --------------------

file.is_exist = function(path)
  local exist = io.open(path, 'r')

  if not exist then
    return false
  end

  exist:close()

  return true
end

file.is_in_cwd = function(path)
  local cwd = M.cwd()
  return (string.sub(path, 1, string.len(cwd))) == cwd
end

file.relative_path = function(path)
  return string.gsub(path, M.cwd(), '')
end

-- current_file --------------------

current_file.path = function()
  return vim.api.nvim_buf_get_name(0)
end

current_file.type = function()
  return vim.o.filetype
end

current_file.name = function()
  return vim.fn.fnamemodify(current_file.path(), ':t')
end

current_file.dir = function()
  return vim.fn.fnamemodify(current_file.path(), ':h')
end

current_file.is_in_cwd = function()
  return file.is_in_cwd(current_file.path())
end

current_file.is_exist = function()
  return file.is_exist(current_file.path())
end

M.file = file
M.current_file = current_file

return M
