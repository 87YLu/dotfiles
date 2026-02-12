local get_transparent_enabled = function()
  return Utils.NvimConfig.get('darkmode', true) and Utils.NvimConfig.get('background_transparent', true)
end

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    specs = {
      {
        'akinsho/bufferline.nvim',
        optional = true,
        opts = function(_, opts)
          opts.highlights = require('catppuccin.special.bufferline').get_theme()
        end,
      },
    },
    config = function()
      vim.o.background = Utils.NvimConfig.get('darkmode', true) and 'dark' or 'light'

      local resetColorscheme = function()
        require('catppuccin').setup({
          lsp_styles = {
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
          },
          styles = {
            comments = { 'italic' },
            functions = { 'italic' },
            keywords = { 'italic' },
          },
          transparent_background = get_transparent_enabled(),
          float = {
            transparent = get_transparent_enabled(),
          },
          integrations = {
            cmp = true,
            flash = true,
            grug_far = true,
            gitsigns = true,
            lsp_trouble = true,
            mason = true,
            mini = true,
            noice = true,
            notify = true,
            snacks = true,
            treesitter_context = true,
            which_key = true,
          },
          custom_highlights = function()
            return {
              FlashLabel = { fg = '#ffffff', bg = '#fe0100' },
            }
          end,
        })

        vim.cmd.colorscheme('catppuccin')
      end

      resetColorscheme()

      Utils.Colorscheme = {
        reset = resetColorscheme,
      }
    end,
  },
}
