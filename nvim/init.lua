local global_config = require('native.utils.global_config').get_global_config()

if global_config ~= nil then
  for key, value in pairs(global_config) do
    vim.g[key] = value
  end
end

require('native.basic.configs')
require('native.basic.plugins')
require('native.basic.keymaps')
require('native.basic.autocmds')
