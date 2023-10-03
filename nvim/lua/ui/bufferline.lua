-- https://github.com/akinsho/bufferline.nvim
local status_ok, bufferline = pcall(require, 'bufferline')

if not status_ok then
  vim.notify('bufferline not found!')
  return
end

local hbac = require('hbac.state')

bufferline.setup({
  options = {
    -- from moll/vim-bbye
    close_command = 'Bdelete! %d',
    right_mouse_command = 'Bdelete! %d',
    show_tab_indicators = true,
    indicator = {
      style = 'underline',
    },
    name_formatter = function(buf)
      return ((hbac.is_pinned(buf.bufnr) and hbac.autoclose_enabled) and ' ' or '') .. buf.name
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'NeoTree',
        highlight = 'Directory',
        text_align = 'center',
      },
    },
  },
})
