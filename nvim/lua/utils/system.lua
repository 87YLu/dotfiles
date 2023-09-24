local M = {}

local is_macos = vim.fn.has('mac') == 1

local function is_apple_silicon()
  if not is_macos then
    return false
  end

  local f = io.popen('sysctl -n machdep.cpu.brand_string')
  if f == nil then
    return false
  end

  local result = f:read('*a')
  f:close()

  return result:find('Apple M') ~= nil
end

M.is_macos = is_macos

M.is_apple_silicon = is_apple_silicon()

return M
