local M = {}
local is_macos = vim.fn.has('mac') == 1
local en_input_mode_name = 'ABC'

local get_mode = function()
  if not is_macos then
    return ''
  end

  local handle = io.popen(
    "defaults read com.apple.HIToolbox AppleSelectedInputSources | grep -o 'KeyboardLayout Name.*' | awk '{print $NF}' | tr -d ';'"
  )

  if handle == nil then
    return
  end

  local input_mode = handle:read('*a'):match('^%s*(.-)%s*$')

  handle:close()

  return input_mode == en_input_mode_name and 'en' or 'zh'
end

local toggle = function()
  if is_macos then
    os.execute('osascript -e \'tell application "System Events" to keystroke space using {control down, option down}\'')
  end
end

M.to_en = function()
  if get_mode() ~= 'en' then
    toggle()
  end
end

return M
