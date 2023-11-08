local M = {}
local common_utils = require('utils.common')

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

return M
