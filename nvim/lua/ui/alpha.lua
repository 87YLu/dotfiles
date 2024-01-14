-- https://github.com/goolord/alpha-nvim
return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VimEnter',
  config = function()
    if vim.g.session_exist then
      return
    end

    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

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
      return ' ' .. v.major .. '.' .. v.minor .. '.' .. v.patch
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
  end,
}
