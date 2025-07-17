-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  config = function()
    local color_utils = require('native.utils.color')

    local function make_hl_groups(opts)
      local color_groups = {}
      local base_bg = color_utils.decompose_color(opts.base_hl)

      for i, color in ipairs(opts.colors) do
        local rainbow_color = color_utils.decompose_color(color)
        local mixed_color = color_utils.mix_colors(rainbow_color, base_bg, opts.transparency)
        local group_name = 'IndentBlanklineRainbowColor' .. i
        vim.api.nvim_set_hl(0, group_name, { bg = color_utils.compose_color(mixed_color) })
        table.insert(color_groups, group_name)
      end

      return color_groups
    end

    local base_hl_list = {
      catppuccin = 0x202332,
      github = 0x2b2e35,
      tokyonight = 0x181a22,
      tokyonight_day = 0xdddde4,
    }

    local setup = function()
      local config = {
        base_hl = base_hl_list[vim.g.colorscheme],
        colors = { 0xE06C75, 0xE5C07B, 0x61AFEF, 0xD19A66, 0x98C379, 0xC678DD, 0x56B6C2 },
        transparency = 0.15,
      }

      local highlight = make_hl_groups(config)

      require('ibl').setup({
        indent = { smart_indent_cap = false },
        whitespace = { highlight = highlight, remove_blankline_trail = false },
        scope = {
          enabled = true,
          char = '𝄀',
          show_start = false,
          show_end = false,
          -- highlight = { 'NonText' },
        },
      })
    end

    color_utils.color_scheme_observer(setup, true)
  end,
}
