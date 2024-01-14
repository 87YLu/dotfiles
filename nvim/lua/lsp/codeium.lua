-- https://github.com/Exafunction/codeium.vim

-- NOTE:
-- language server 下载经常出问题, 可以在 https://github.com/Exafunction/codeium/releases 手动下载
-- 然后访问 ~/.local/share/nvim/lazy/codeium.vim/autoload/codeium/server.vim 获取 sha
-- 把下载好的 language server 放到 ~/.codeium/bin/<sha> 中
-- https://github.com/Exafunction/codeium.vim/issues/35

return {
  'Exafunction/codeium.vim',
  event = 'VeryLazy',
  config = function()
    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_filetypes = {
      TelescopePrompt = false,
    }
    require('basic.keymaps').codeium()
  end,
}
