-- https://github.com/lewis6991/gitsigns.nvim
local status_ok, gitsigns = pcall(require, 'gitsigns')

if not status_ok then
  vim.notify('gitsigns not found!')
  return
end

local plugin_keys = require('basic.keymaps')

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.*',
  once = true,
  callback = function()
    gitsigns.setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        plugin_keys.gitsigns(map, gs)
      end,
    })
  end,
})
