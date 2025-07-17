-- https://github.com/folke/noice.nvim
return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = function()
    require('notify').setup({
      stages = 'static',
      render = 'compact',
      timeout = 2500,
    })

    require('noice').setup({
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = { find = 'sumneko' },
          opts = { skip = true },
        },
      },
      views = {
        cmdline_popup = {
          backend = 'popup',
          relative = 'editor',
          zindex = 200,
          position = {
            row = '50%',
            col = '50%',
          },
          size = {
            width = 80,
            height = 'auto',
          },
        },
        popupmenu = {
          position = {
            row = 'auto',
            col = 'auto',
          },
          size = {
            width = 120,
            height = 'auto',
          },
          border = {
            padding = { 0, 1 },
          },
        },
      },
    })
  end,
}
