-- https://github.com/akinsho/bufferline.nvim
return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  config = function()
    local buffers = {}

    local has_hbac, hbac = pcall(require, 'hbac.state')

    require('bufferline').setup({
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
        get_element_icon = has_hbac
            and function(element)
              local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype)
              if icon ~= nil then
                return ((hbac.is_pinned(buffers[element.path]) and hbac.autoclose_enabled) and '📍 ' or '') .. icon,
                  hl
              end
              return nil
            end
          or nil,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'NeoTree',
            text_align = 'center',
          },
        },
      },
    })

    require('basic.keymaps').bufferline()
  end,
}
