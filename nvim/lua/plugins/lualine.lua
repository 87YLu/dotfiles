local disabled_types = {
  'snacks_dashboard',
  'NvimTree',
  'grug-far',
  'DiffviewFiles',
}

return {
  'nvim-lualine/lualine.nvim',
  event = 'LazyFile',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local lualine = require('lualine')

    local config = {
      options = {
        component_separators = '',
        section_separators = '',
        disabled_filetypes = {
          tabline = disabled_types,
          statusline = disabled_types,
          winbar = disabled_types,
        },
      },
      sections = {
        lualine_a = { { 'mode' } },
        lualine_b = { { 'branch', icon = '' } },
        lualine_c = {
          {
            Utils.Lualine.lsp_progress(lualine),
          },
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = {
              error = Icons.diagnostics.Error,
              warn = Icons.diagnostics.Warn,
              info = Icons.diagnostics.Info,
              hint = Icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          {
            'encoding',
            fmt = function(str)
              return string.upper(str)
            end,
          },
          {
            'fileformat',
            symbols = {
              unix = 'LF',
              dos = 'CRLF',
              mac = 'CR',
            },
          },
          Utils.Lualine.open_ide,
          Utils.Lualine.open_sublime_merge,
        },
        lualine_y = { {
          Utils.Lualine.language_server,
        } },
        lualine_z = { { 'location' } },
      },
      winbar = {
        lualine_c = {
          Utils.Lualine.lsp_breadcrumb,
        },
        lualine_x = {
          {
            'diff',
            symbols = { added = Icons.git.added, modified = Icons.git.modified, removed = Icons.git.removed },
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          Utils.Lualine.lsp_breadcrumb,
        },
        lualine_x = {
          {
            'diff',
            symbols = { added = Icons.git.added, modified = Icons.git.modified, removed = Icons.git.removed },
          },
        },
      },
    }

    lualine.setup(config)
  end,
}
