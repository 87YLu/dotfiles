local M = {}
local en_input_mode_name = 'ABC'
local system = require('utils.system')

M.mode = function()
  if not system.is_macos then
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

  if input_mode == en_input_mode_name then
    return 'en'
  else
    return 'zh'
  end
end

M.toggle = function()
  if not system.is_macos then
    return
  end

  os.execute('osascript -e \'tell application "System Events" to keystroke space using {control down, option down}\'')
end

M.to_zh = function()
  if M.mode() ~= 'zh' then
    M.toggle()
  end
end

M.to_en = function()
  if M.mode() ~= 'en' then
    M.toggle()
  end
end

return M
