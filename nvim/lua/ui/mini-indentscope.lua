-- https://github.com/echasnovski/mini.indentscope
require('mini.indentscope').setup({
  symbol = '𝄀',
})

local color_utils = require('utils.color')

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    local current_buffer = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(current_buffer)

    vim.g.miniindentscope_disable = line_count > 3000
  end,
})

color_utils.color_scheme_observer(function()
  local color = color_utils.get_color_fg('Comment')
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = color })
end, true)
