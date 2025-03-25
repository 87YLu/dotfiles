local M = {}

M.get_color = function(color, format)
  local hl = vim.api.nvim_get_hl_by_name(color, true)

  if format ~= true then
    return hl
  end

  local foreground = hl.foreground and string.format('#%06x', hl.foreground) or nil
  local background = hl.background and string.format('#%06x', hl.background) or nil

  return {
    foreground = foreground,
    background = background,
  }
end

M.get_color_fg = function(color, format)
  return M.get_color(color, format).foreground
end

M.get_color_bg = function(color, format)
  return M.get_color(color, format).background
end

M.mix_colors = function(color_a, color_b, transparency)
  return {
    color_a[1] * transparency + color_b[1] * (1 - transparency),
    color_a[2] * transparency + color_b[2] * (1 - transparency),
    color_a[3] * transparency + color_b[3] * (1 - transparency),
  }
end

M.decompose_color = function(color)
  local blue = color % 256
  local green = (color - blue) / 256 % 256
  local red = (color - green * 256 - blue) / 256 / 256
  return { red, green, blue }
end

M.compose_color = function(color)
  return math.floor(math.floor(color[3]) + math.floor(color[2]) * 256 + math.floor(color[1]) * 256 * 256)
end

local group = vim.api.nvim_create_augroup('color_scheme_observer', { clear = true })

M.color_scheme_observer = function(callback, immediate)
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = group,
    callback = function()
      callback()
    end,
  })

  if immediate == true then
    callback()
  end
end

return M
