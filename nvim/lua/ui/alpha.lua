-- https://github.com/goolord/alpha-nvim
local status_ok, alpha = pcall(require, 'alpha')

if not status_ok then
  vim.notify('alpha not found!')
  return
end

local dashboard = require('alpha.themes.dashboard')

-- if there is a session, alpha doesn't need to be loaded
if require('session_manager.config').dir_to_session_filename(vim.loop.cwd()):exists() then
  return
end

dashboard.section.header.val = {
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[    █████╗  ███████╗ ██╗   ██╗ ██╗      ██╗   ██╗  ]],
  [[   ██╔══██╗ ╚════██║ ╚██╗ ██╔╝ ██║      ██║   ██║  ]],
  [[   ╚█████╔╝     ██╔╝  ╚████╔╝  ██║      ██║   ██║  ]],
  [[   ██╔══██╗    ██╔╝    ╚██╔╝   ██║      ██║   ██║  ]],
  [[   ╚█████╔╝    ██║      ██║    ███████╗ ╚██████╔╝  ]],
  [[    ╚════╝     ╚═╝      ╚═╝    ╚══════╝  ╚═════╝   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
  [[                                                   ]],
}

dashboard.section.buttons.val = {
  dashboard.button('n', '  New File', ':enew<CR>'),
  dashboard.button('p', '  Projects', ':Telescope projects<CR>'),
  dashboard.button('r', '  Recently files', ':Telescope oldfiles<CR>'),
  dashboard.button('k', '󰥻  Edit keymaps', ':edit ~/.config/nvim/lua/basic/keymaps.lua<CR>'),
  dashboard.button('f', '  Edit Projects', ':edit ~/.local/share/nvim/project_nvim/project_history<CR>'),
  dashboard.button('q', '󰗼  Quit', ':qa<CR>'),
}

local function footer()
  local v = vim.version()
  return ' ' .. v.major .. '.' .. v.minor .. '.' .. v.patch
end

dashboard.section.footer.val = footer()

dashboard.opts.opts.noautocmd = true

dashboard.section.header.opts.hl = 'Function'
dashboard.section.footer.opts.hl = 'Function'

alpha.setup(dashboard.opts)
