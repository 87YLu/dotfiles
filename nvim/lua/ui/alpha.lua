-- https://github.com/goolord/alpha-nvim
local status_ok, alpha = pcall(require, 'alpha')

if not status_ok then
  vim.notify('alpha not found!')
  return
end

local dashboard = require('alpha.themes.dashboard')

-- if there is a session, alpha doesn't need to be loaded
if require('utils').session_exist() then
  return
end

dashboard.section.header.val = {
  [[    █████╗  ███████╗ ██╗   ██╗ ██╗      ██╗   ██╗  ]],
  [[   ██╔══██╗ ╚════██║ ╚██╗ ██╔╝ ██║      ██║   ██║  ]],
  [[   ╚█████╔╝     ██╔╝  ╚████╔╝  ██║      ██║   ██║  ]],
  [[   ██╔══██╗    ██╔╝    ╚██╔╝   ██║      ██║   ██║  ]],
  [[   ╚█████╔╝    ██║      ██║    ███████╗ ╚██████╔╝  ]],
  [[    ╚════╝     ╚═╝      ╚═╝    ╚══════╝  ╚═════╝   ]],
}

dashboard.section.buttons.val = {
  dashboard.button('n', '  New File', ':enew<CR>'),
  dashboard.button('p', '  Projects', ':lua require("telescope").extensions.projects.projects()<CR>'),
  dashboard.button('r', '  Recently files', ':lua require("telescope.builtin").oldfiles()<CR>'),
  dashboard.button('c', '  Edit configs', ':edit ~/.config/nvim/lua/basic/configs.lua<CR>'),
  dashboard.button('k', '󰥻  Edit keymaps', ':edit ~/.config/nvim/lua/basic/keymaps.lua<CR>'),
  dashboard.button('f', '  Edit Projects', ':edit ~/.local/share/nvim/project_nvim/project_history<CR>'),
  dashboard.button('q', '󰗼  Quit', ':qa<CR>'),
}

local function footer()
  local v = vim.version()
  return ' ' .. v.major .. '.' .. v.minor .. '.' .. v.patch
end

dashboard.section.footer.val = footer()

dashboard.section.header.opts.hl = 'Function'
dashboard.section.footer.opts.hl = 'Function'

local marginTopPercent = 0.2
local fn = vim.fn
local headerPadding = fn.max({ 2, fn.floor(fn.winheight(0) * marginTopPercent) })

dashboard.config.layout = {
  { type = 'padding', val = headerPadding },
  dashboard.section.header,
  { type = 'padding', val = 4 },
  dashboard.section.buttons,
  { type = 'padding', val = 2 },
  dashboard.section.footer,
}

alpha.setup(dashboard.config)
