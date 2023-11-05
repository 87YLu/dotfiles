-- https://github.com/akinsho/bufferline.nvim
local hbac = require('hbac.state')

local buffers = {}

vim.cmd('highlight CatPinned guifg=#E74C3C')

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
      buffers[buf.path] = buf.bufnr
      return buf.name
    end,
    get_element_icon = function(element)
      local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype)
      if icon ~= nil then
        return ((hbac.is_pinned(buffers[element.path]) and hbac.autoclose_enabled) and '📍 ' or '') .. icon, hl
      end
      return nil
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'NeoTree',
        text_align = 'center',
      },
    },
  },
})
