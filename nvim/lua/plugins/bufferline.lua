return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup({
      options = {
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        diagnostics = 'nvim_lsp',
        show_tab_indicators = true,
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = Icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
            .. (diag.warning and icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'center',
          },
          {
            filetype = 'grug-far',
            text = 'Search And Replace',
            text_align = 'center',
          },
          {
            filetype = 'DiffviewFiles',
            text = 'Diff File Explorer',
            text_align = 'center',
          },
        },
      },
    })

    vim.keymap.set(
      'n',
      PluginsKeyMapping.BufferLine.prevBuffer.key,
      '<cmd>BufferLineCyclePrev<CR>',
      { desc = PluginsKeyMapping.BufferLine.prevBuffer.desc }
    )
    vim.keymap.set(
      'n',
      PluginsKeyMapping.BufferLine.nextBuffer.key,
      '<cmd>BufferLineCycleNext<CR>',
      { desc = PluginsKeyMapping.BufferLine.nextBuffer.desc }
    )
    vim.keymap.set(
      'n',
      PluginsKeyMapping.BufferLine.pickClose.key,
      '<cmd>BufferLinePickClose<CR>',
      { desc = PluginsKeyMapping.BufferLine.pickClose.desc }
    )
  end,
}
