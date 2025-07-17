local plugins = {
  -- ui
  require('native.ui.alpha'),
  require('native.ui.bufferline'),
  require('native.ui.colorscheme'),
  require('native.ui.indent-blankline'),
  require('native.ui.lualine'),
  require('native.ui.neo-tree'),
  require('native.ui.noice'),
  require('native.ui.nvim-ufo'),
  require('native.ui.nvim-colorizer'),
  -- enhance
  require('native.enhance.comment'),
  require('native.enhance.diffview'),
  require('native.enhance.faster'),
  require('native.enhance.gitsigns'),
  require('native.enhance.harpoon'),
  require('native.enhance.hbac'),
  require('native.enhance.markview'),
  require('native.enhance.nvim-autopairs'),
  require('native.enhance.nvim-surround'),
  require('native.enhance.persistence'),
  require('native.enhance.project'),
  require('native.enhance.telescope'),
  require('native.enhance.todo-comments'),
  require('native.enhance.toggleterm'),
  require('native.enhance.whick-key'),
  -- lsp
  require('native.lsp.cmp'),
  require('native.lsp.codeium'),
  require('native.lsp.lsp-config'),
  require('native.lsp.nvim-custom-diagnostic-highlight'),
  require('native.lsp.nvim-lint'),
}

return plugins
