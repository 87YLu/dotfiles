local M = {}

local config_dir = vim.fn.stdpath('config')

local global_config_json = config_dir .. '/global_config.json'

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

M.config_dir = config_dir

M.get_global_config = function(key)
  local file = io.open(global_config_json, 'r')
  local json

  if file then
    local content = file:read('*a')
    file:close()
    json = vim.fn.json_decode(content == '' and '{}' or content)
  else
    json = vim.fn.json_decode('{}')
  end

  if key ~= nil and json ~= nil then
    for _key, value in ipairs(json) do
      if key == _key then
        return value
      end
    end
    return nil
  else
    return json
  end
end

M.set_global_config = function(key, value)
  local json = M.get_global_config()
  local file = io.open(global_config_json, 'w')

  if file then
    json[key] = value
    file:write(format_json(vim.fn.json_encode(json)))
    file:close()
  end
end

return M
