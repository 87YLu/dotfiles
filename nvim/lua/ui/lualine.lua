-- https://github.com/nvim-lualine/lualine.nvim
local lualine = require('lualine')
local hbac = require('hbac.state')
local common_utils = require('utils.common')
local input_mode = require('utils.input_mode')
local system = require('utils.system')
local color_utils = require('utils.color')
local current_file = require('utils.current_file')

local get_color = function(color)
  return {
    fg = color_utils.get_color_fg(color, true),
  }
end

local path_count = 3

local path = function()
  local file_path = current_file.relative_path()
  local separator = package.config:sub(1, 1)
  local segments = {}

  for segment in file_path:gmatch('[^' .. separator .. ']+') do
    table.insert(segments, segment)
  end

  if #segments <= path_count then
    return file_path
  end

  local shortenedSegments = {}
  for i = #segments - path_count + 1, #segments do
    table.insert(shortenedSegments, segments[i])
  end

  return table.concat({ '...', unpack(shortenedSegments) }, separator)
end

local function nav()
  local items = vim.b.coc_nav or {}
  local t = { '%#NonText#' .. '' }
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
      tabline = { 'alpha', 'neo-tree', 'coctree' },
      statusline = { 'alpha', 'DiffviewFiles', 'coctree' },
      winbar = { 'neo-tree', 'alpha', 'DiffviewFiles', 'coctree' },
    },
    refresh = {
      statusline = 2000,
    },
  },
  winbar = {
    lualine_a = {
      path,
      { nav, padding = { left = 0 } },
    },
  },
  inactive_winbar = {
    lualine_a = { { path, color = get_color('Comment') } },
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
  'branch',
  icon = '',
  color = function()
    return get_color('@tag')
  end,
  padding = { left = 2, right = 1 },
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
  padding = { left = 1, right = 1 },
})

ins_left({
  function()
    if current_file.is_in_types({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) then
      return string.gsub(vim.g.coc_status or '', 'cSpell', '')
    end
    return ''
  end,
  padding = { left = 0, right = 1 },
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
})

ins_right({
  function()
    return '󰨞'
  end,
  color = {
    fg = '#3790E9',
  },
  on_click = function()
    vim.cmd('!code ' .. common_utils.cwd() .. ' --goto ' .. current_file.path())
  end,
  padding = { left = 1, right = 2 },
})

lualine.setup(config)
