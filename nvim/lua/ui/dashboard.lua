-- https://github.com/glepnir/dashboard-nvim
local status_ok, dashboard = pcall(require, 'dashboard')

if not status_ok then
  vim.notify('dashboard not found!')
  return
end

local v = vim.version()
local version = ' ' .. v.major .. '.' .. v.minor .. '.' .. v.patch

dashboard.setup({
  theme = 'doom',
  config = {
    header = {
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
    },
    center = {
      {
        icon = '  ',
        desc = 'New File',
        action = ':enew',
        key = 'n',
      },
      {
        icon = '  ',
        desc = 'Projects',
        action = 'Telescope projects',
        key = 'p',
      },
      {
        icon = '  ',
        desc = 'Recently files',
        action = 'Telescope oldfiles',
        key = 'r',
      },
      {
        icon = '  ',
        desc = 'Edit keymaps',
        action = 'edit ~/.config/nvim/lua/basic/keymaps.lua',
        key = 'k',
      },
      {
        icon = '  ',
        desc = 'Edit Projects',
        action = 'edit ~/.local/share/nvim/project_nvim/project_history',
        key = 'f',
      },
      {
        icon = '  ',
        desc = 'Quit',
        action = ':qa',
        key = 'q',
      },
    },
    footer = {
      '',
      version,
    },
  },
})
