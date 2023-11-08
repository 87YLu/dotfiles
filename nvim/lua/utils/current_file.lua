local M = {}
local file_utils = require('utils.file')

M.path = function()
  return vim.api.nvim_buf_get_name(0)
end

M.relative_path = function()
  return file_utils.relative_path(M.path())
end

M.type = function()
  return vim.o.filetype
end

M.name = function()
  return vim.fn.fnamemodify(M.path(), ':t')
end

M.dir = function()
  return vim.fn.fnamemodify(M.path(), ':h')
end

M.is_in_cwd = function()
  return file_utils.is_in_cwd(M.path())
end

M.is_exist = function()
  return file_utils.is_exist(M.path())
end

M.is_in_types = function(types)
  return string.find(table.concat(types, ''), M.type()) ~= nil
end

return M
