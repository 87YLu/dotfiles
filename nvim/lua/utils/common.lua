local M = {}

M.cwd = function()
  return vim.loop.cwd()
end

M.homedir = function()
  return vim.loop.os_homedir()
end

M.session_exist = function()
  if require('session_manager.config').dir_to_session_filename(M.cwd()):exists() then
    return true
  end

  return false
end

M.set_timeout = function(func, delay)
  local timer = vim.loop.new_timer()
  timer:start(
    delay,
    0,
    vim.schedule_wrap(function()
      func()
      timer:stop()
    end)
  )
end

M.copy = function(content)
  vim.fn.setreg('+', content)
  vim.fn.setreg('"', content)
  vim.notify(string.format('Copied %s to system clipboard!', content))
end

return M
