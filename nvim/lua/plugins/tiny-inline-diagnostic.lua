return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'LspAttach',
  priority = 1000,
  opts = {
    preset = 'powerline',
    options = {
      multilines = {
        enabled = true,
        always_show = true,
      },
      show_source = true,
      throttle = 100,
      overflow = {
        mode = 'wrap',
      },
      softwrap = 30,
      multiple_diag_under_cursor = true,
      virt_texts = {
        priority = 2048,
      },
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      },
    },
  },
  config = function(_, opts)
    vim.diagnostic.config({ virtual_text = false })

    require('tiny-inline-diagnostic').setup(opts)

    if not Utils.NvimConfig.get('virtual_text', true) then
      require('tiny-inline-diagnostic').disable()
    end
  end,
}
