local global_config = require('utils.global_config').get_global_config()

if global_config ~= nil then
  for key, value in pairs(global_config) do
    vim.g[key] = value
  end
end

require('basic.configs')
require('basic.plugins')
require('basic.keymaps')
require('basic.autocmds')
