-- https://github.com/terrortylor/nvim-comment
local status_ok, nvim_comment = pcall(require, 'nvim_comment')

if not status_ok then
  vim.notify('nvim_comment not found!')
  return
end

nvim_comment.setup({
  create_mappings = false,
  comment_empty = false,
  comment_empty_trim_whitespace = true,
})

-- vim.cmd([[
--   augroup set-commentstring-ag
--     autocmd!
--     autocmd BufEnter *.sh, *.toml :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
--     autocmd BufFilePost *.sh, *.toml :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
--   augroup END
-- ]])
