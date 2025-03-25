-- https://wezfurlong.org/wezterm/config/lua/config/index.html
local wezterm = require('wezterm')
local config = {}

-- color
config.color_scheme = 'Tokyo Night Moon'
config.colors = {
  cursor_bg = '#52ad70',
  background = '#24273a',
}

-- font
local zhCN = {
  -- https://github.com/lxgw/LxgwWenkaiGB
  XiaWuWenKai = {
    family = 'LXGW WenKai Mono GB',
    scale = 1.1,
    weight = 'Bold',
  },
  -- https://www.foundertype.com/index.php/FontInfo/index/id/214
  FangZhengYanSong = {
    family = 'FZYanSongS-R-GB',
    scale = 1.05,
  },
}

config.font = wezterm.font_with_fallback({
  {
    family = 'JetBrainsMono Nerd Font',
    weight = 'Medium',
  },
  zhCN.FangZhengYanSong,
})
config.font_size = 16
config.freetype_load_target = 'HorizontalLcd'
config.freetype_render_target = 'HorizontalLcd'

-- window
config.window_background_opacity = 0.96
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- underline
config.underline_thickness = '2pt'

return config
