-- https://github.com/axkirillov/hbac.nvim
-- 控制 tab 数量
return {
  'axkirillov/hbac.nvim',
  event = 'VeryLazy',
  config = function()
    local hbac = require('hbac')
    local hbac_state = require('hbac.state')
    local global_config_utils = require('native.utils.global_config')

    hbac.setup({
      autoclose = (vim.g.hbac_autoclose == nil) and true or vim.g.hbac_autoclose,
      threshold = 5,
      close_command = function(bufnr)
        vim.api.nvim_buf_delete(bufnr, {})
      end,
      close_buffers_with_windows = false,
    })

    local keys = require('common.basic.keymaps').hbac

    vim.g.keyset('n', keys.toggle, hbac.toggle_pin, { desc = 'toggle pin' })
    vim.g.keyset('n', keys.toggle_autoclose, function()
      hbac.toggle_autoclose()
      global_config_utils.set_global_config('hbac_autoclose', hbac_state.autoclose_enabled)
    end, { desc = 'toggle autoclose' })
  end,
}
