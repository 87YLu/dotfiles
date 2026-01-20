local M = {}

local config_path = vim.fn.stdpath('config') .. '/nvim-config.json'

local format_json = function(jsonString)
  local command = string.format("echo '%s' | jq .", jsonString)
  local handle = io.popen(command)
  if handle ~= nil then
    local formattedJson = handle:read('*a')
    handle:close()
    return formattedJson
  else
    return ''
  end
end

local cache = {}

M.get = function(key, default)
  if cache[key] then
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
    return json[key] == nil and default or json[key]
  else
    return json
  end
end

M.set = function(key, value)
  local json = M.get()
  local file = io.open(config_path, 'w')

  if file then
    json[key] = value
    file:write(format_json(vim.fn.json_encode(json)))
    file:close()
  end

  cache[key] = value
end

return M
