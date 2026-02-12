local M = {}

M.Path = require('utils.path')
M.GrugFar = require('utils.grug-far')
M.NvimConfig = require('utils.nvim-config')
M.Dashboard = require('utils.dashboard')
M.Lualine = require('utils.lualine')
M.Image = require('utils.image')

local _defaults = {}

M.set_default = function(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = 'local' })
  local g = vim.api.nvim_get_option_value(option, { scope = 'global' })

  _defaults[('%s=%s'):format(option, value)] = true
  local key = ('%s=%s'):format(option, l)

  if l ~= g and not _defaults[key] then
    -- Option does not match global and is not a default value
    -- Check if it was set by a script in $VIMRUNTIME
    local info = vim.api.nvim_get_option_info2(option, { scope = 'local' })
    local scriptinfo = vim.tbl_filter(function(e)
      return e.sid == info.last_set_sid
    end, vim.fn.getscriptinfo())
    local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand('$VIMRUNTIME'))
    if not by_rtp then
      return false
    end
  end

  vim.api.nvim_set_option_value(option, value, { scope = 'local' })
  return true
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes('<c-G>u', true, true, true)

M.create_undo = function()
  if vim.api.nvim_get_mode().mode == 'i' then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, 'n', false)
  end
end

M.copy = function(content)
  vim.fn.setreg('+', content)
  vim.fn.setreg('"', content)
  vim.notify(string.format('Copied %s to system clipboard!', content))
end

return M
