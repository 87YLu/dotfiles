-- https://github.com/axkirillov/hbac.nvim
require('hbac').setup({
  autoclose = (vim.g.hbac_autoclose == nil) and true or vim.g.hbac_autoclose,
  threshold = 5,
  close_command = function(bufnr)
    vim.api.nvim_buf_delete(bufnr, {})
  end,
  close_buffers_with_windows = false,
})
