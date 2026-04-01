local is_dark = function()
  return Utils.NvimConfig.get('darkmode', true)
end

local catppuccin = function()
  vim.o.background = 'dark'

  local ok, c = pcall(require, 'catppuccin')

  if ok then
    c.setup({
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
      transparent_background = Utils.NvimConfig.get('background_transparent', true),
      float = {
        transparent = Utils.NvimConfig.get('background_transparent', true),
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
  end
  vim.cmd.colorscheme('catppuccin')
end

local everforest = function()
  vim.o.background = 'light'
  vim.g.everforest_background = 'medium'
  vim.g.everforest_better_performance = 1
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_diagnostic_text_highlight = 1
  vim.g.everforest_diagnostic_virtual_text = 'colored'
  vim.g.everforest_ui_contrast = 'high'
  vim.g.everforest_float_style = 'bright'
  vim.g.everforest_transparent_background = 0
  vim.cmd.colorscheme('everforest')
end

local function apply_theme(is_dark_mode)
  local dark = is_dark_mode ~= nil and is_dark_mode or is_dark()
  if dark then
    catppuccin()
  else
    everforest()
  end

  pcall(function()
    Utils.Colorscheme.sync(dark)
  end)
end

Utils.Colorscheme.reset = apply_theme

return {
  -- Dark: Catppuccin
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    config = function()
      if is_dark() then
        apply_theme(true)
      end
    end,
  },
  -- Light: Everforest
  {
    'sainnhe/everforest',
    priority = 1000,
    lazy = false,
    config = function()
      if not is_dark() then
        apply_theme(false)
      end
    end,
  },
}
