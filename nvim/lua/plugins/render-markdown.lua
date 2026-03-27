return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {
    indent = {
      enabled = true,
      per_level = 1,
      icon = '',
    },
    checkbox = {
      enabled = false,
    },
    code = {
      sign = false,
    },
  },
}
