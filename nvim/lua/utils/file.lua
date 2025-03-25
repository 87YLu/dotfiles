local common_utils = require('utils.common')
local M = {}

M.is_exist = function(path)
  local exist = io.open(path, 'r')

  if not exist then
    return false
  end

  exist:close()

  return true
end

M.is_in_cwd = function(path)
  local cwd = common_utils.cwd()
  return (string.sub(path, 1, string.len(cwd))) == cwd
end

M.relative_path = function(path)
  return string.gsub(path, common_utils.cwd() .. '/', '')
end

M.get_content = function(path, default_content)
  local _file = io.open(path, 'r')
  if _file then
    local content = _file:read('*a')
    _file:close()
    return content
  else
    return default_content
  end
end

M.write_content = function(path, content)
  local _file = io.open(path, 'w')
  if _file then
    _file:write(content)
    _file:close()
  end
end

M.current_path = function()
  return vim.api.nvim_buf_get_name(0)
end

M.current_relative_path = function()
  return M.relative_path(M.current_path())
end

M.current_type = function()
  return vim.o.filetype
end

M.current_name = function()
  return vim.fn.fnamemodify(M.current_path(), ':t')
end

M.curent_dir = function()
  return vim.fn.fnamemodify(M.current_path(), ':h')
end

M.is_current_in_cwd = function()
  return M.is_in_cwd(M.current_path())
end

M.is_current_exist = function()
  return M.is_exist(M.current_path())
end

M.is_current_in_types = function(types)
  return string.find(table.concat(types, ''), M.current_type()) ~= nil
end

return M
