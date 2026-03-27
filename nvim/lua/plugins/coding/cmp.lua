return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'VeryLazy',
  opts = {
    keymap = {
      preset = 'none',
      ['<CR>'] = { 'accept', 'fallback' },
      [PluginsKeyMapping.Cmp.nextItem.key] = { 'show', 'select_next', 'fallback' },
      [PluginsKeyMapping.Cmp.prevItem.key] = { 'show', 'select_prev', 'fallback' },
      [PluginsKeyMapping.Cmp.snipParamsNext.key] = { 'snippet_forward', 'fallback' },
      [PluginsKeyMapping.Cmp.snipParamsPrev.key] = { 'snippet_backward', 'fallback' },
    },
    cmdline = {
      keymap = {
        preset = 'none',
        ['<CR>'] = { 'accept_and_enter', 'fallback' },
        ['<C-e>'] = { 'hide', 'fallback' },
        [PluginsKeyMapping.Cmp.nextItem.key] = { 'show', 'select_next', 'fallback' },
        [PluginsKeyMapping.Cmp.prevItem.key] = { 'show', 'select_prev', 'fallback' },
      },
    },
    appearance = {
      nerd_font_variant = 'mono',
      kind_icons = Icons.kinds,
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      menu = {
        border = 'rounded',
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
          },
          treesitter = { 'lsp' },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = 'rounded',
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = 'rounded',
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    snippets = {
      preset = 'default',
    },
  },
}
