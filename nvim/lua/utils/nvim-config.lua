local M = {}

local config_path = vim.fn.stdpath('config') .. '/nvim-config.json'

local cache = {}

M.get = function(key, default)
  if key ~= nil and cache[key] ~= nil then
    return cache[key]
  end

  local file = io.open(config_path, 'r')
  local json

  if file then
    local content = file:read('*a')
    file:close()
    json = vim.fn.json_decode(content == '' and '{}' or content)
  else
    json = vim.fn.json_decode('{}')
  end

  if key ~= nil and json ~= nil then
    local value = json[key] == nil and default or json[key]
    cache[key] = value
    return value
  else
    return json
  end
end

M.set = function(key, value)
  local json = M.get()
  local file = io.open(config_path, 'w')

  if file then
    json[key] = value
    local ok, encoded = pcall(vim.fn.json_encode, json)
    file:write(ok and encoded or '{}')
    file:close()
  end

  cache[key] = value
end

return M
