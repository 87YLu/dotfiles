local lualine = require('lualine')
local hbac = require('hbac.state')
local input_mode = require('utils.input_mode')
local system = require('utils.system')

local function get_color(color)
  local hl = vim.api.nvim_get_hl_by_name(color, true)
  return {
    fg = hl.foreground and string.format('#%06x', hl.foreground) or nil,
  }
end

local function nav()
  local items = vim.b.coc_nav or {}
  local t = { '%#NonText#' .. '    ' }
  for k, v in ipairs(items) do
    t[#t + 1] = ' %#'
      .. (v.highlight or 'NormalNC')
      .. '#'
      .. (type(v.label) == 'string' and v.label .. ' ' or ' ')
      .. '%#Comment#'
      .. (v.name or '')
    if next(items, k) ~= nil then
      t[#t + 1] = '%#NonText# '
    end
  end

  return table.concat(t)
end

local config = {
  options = {
    component_separators = '',
    section_separators = '',
    disabled_filetypes = {
      tabline = { 'alpha', 'neo-tree' },
      statusline = { 'alpha' },
      winbar = { 'neo-tree', 'alpha' },
      refresh = {
        statusline = 2000,
      },
    },
  },
  winbar = {
    lualine_a = { nav },
    lualine_b = { '%#NonText#' .. '' },
  },
  inactive_winbar = {
    lualine_a = { nav },
    lualine_b = { '%#NonText#' .. '' },
  },
  extensions = { 'neo-tree', 'toggleterm' },
  sections = {
    lualine_a = {
      {
        'mode',
        separator = { right = '' },
        padding = { left = 2, right = 2 },
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = {},
    lualine_y = {},
    lualine_z = { 'location' },
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
  'filetype',
  fmt = function()
    return ' '
  end,
  padding = { left = 2, right = 0 },
})

ins_left({
  'branch',
  icon = '',
  color = function()
    return get_color('@tag')
  end,
  padding = { left = 0 },
})

if system.is_apple_silicon then
  ins_left({
    input_mode.mode,
    fmt = string.upper,
    icon = '󰓽',
    color = function()
      return get_color('@character')
    end,
  })
end

ins_left({
  'diagnostics',
  symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' },
})

ins_right({
  'diff',
  symbols = { added = ' ', modified = ' ', removed = ' ' },
  diff_color = {
    added = function()
      return get_color('diffAdded')
    end,
    modified = function()
      return get_color('diffChanged')
    end,
    removed = function()
      return get_color('diffRemoved')
    end,
  },
})

ins_right({
  'tabnine',
  fmt = function(str)
    return str:gsub('tabnine starter', 'tabnine')
  end,
  color = function()
    return get_color('@character.special')
  end,
})

ins_right({
  'encoding',
  fmt = string.upper,
  color = function()
    return get_color('@repeat')
  end,
})

ins_right({
  'fileformat',
  symbols = {
    unix = 'LF',
    dos = 'CRLF',
    mac = 'CR',
  },
  color = function()
    return get_color('@annotation')
  end,
})

ins_right({
  function()
    return hbac.autoclose_enabled and '󰱝' or '󰱞'
  end,
  color = function()
    return hbac.autoclose_enabled and get_color('@string.regex') or get_color('Comment')
  end,
  padding = { left = 1, right = 2 },
})

lualine.setup(config)
