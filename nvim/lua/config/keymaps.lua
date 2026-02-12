local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local M = {
  BufferLine = {},
  Cmp = {},
  Conform = {},
  DiffView = {},
  GitSigns = {},
  GrugFar = {},
  Harpoon = {},
  LspSaga = {},
  Mason = {},
  Neogit = {},
  NvimTree = {},
  Snacks = {},
  Window = {},
}

_G.PluginsKeyMapping = M

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- speed move
map('n', '<C-j>', '10j', { desc = 'cursor moves down 10 lines' })
map('n', '<C-k>', '10k', { desc = 'cursor moves up 10 lines' })
map('n', 'H', '^', { desc = 'Move to the beginning of the line' })
map('n', 'L', '$', { desc = 'Move to the ending of the line' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Resize window
map('n', "<A-'>", '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<A-;>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<A-,>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<A-.>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })
map('n', '<A-=>', '<C-w>=', { desc = 'equal all windows' })
M.Window.decrease = {
  key = '<A-,>',
  desc = 'Decrease Width',
}
M.Window.increase = {
  key = '<A-.>',
  desc = 'Increase Width',
}

-- Move to window
map('n', '<A-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
map('n', '<A-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
map('n', '<A-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
map('n', '<A-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- Close window
map('n', '<leader>wc', '<C-w>c', { desc = 'Close Current Window' })
map('n', '<leader>wo', '<C-w>o', { desc = 'Close Other Windows' })

-- Move Lines
map('v', 'J', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
map('v', 'K', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- save file
map({ 'x', 'n', 's' }, '<leader><leader>', '<cmd>w<cr><esc>', { desc = 'Save File' })

-- better indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

-- commenting
map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- copy
map('n', '<leader>yp', function()
  Utils.copy(Utils.Path.get_current_path())
end, { desc = 'Copy Current File Path' })
map('n', '<leader>yP', function()
  Utils.copy(Utils.Path.get_project_root())
end, { desc = 'Copy Current Project Path' })

-- quit
map('n', '<leader>qq', function()
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd('tabc')
  else
    vim.cmd('qa')
  end
end, { desc = 'Quit' })

-- tab
map('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '[t', '<cmd>tabprev<cr>', { desc = 'Prev Tab' })

-- buffers
M.BufferLine = {
  prevBuffer = {
    key = '[b',
    desc = 'Prev Buffer',
  },
  nextBuffer = {
    key = ']b',
    desc = 'Next Buffer',
  },
  pickClose = {
    key = '<leader>bp',
    desc = 'Pick Buffer To Close',
  },
}
M.Snacks.buffer = {
  delete = {
    key = '<leader>bd',
    desc = 'Delete Buffer',
  },
  deleteOther = {
    key = '<leader>bo',
    desc = 'Delete Other Buffer',
  },
}

-- file/find
M.NvimTree.toggle = {
  key = '<leader>fe',
  desc = 'File Explorer',
}
M.Snacks.find = {
  buffer = {
    key = '<leader>fb',
    desc = 'Buffer',
  },
  recent = {
    key = '<leader>fr',
    desc = 'Recent',
  },
  file = {
    key = '<leader>ff',
    desc = 'Find File',
  },
}

-- search
M.GrugFar = {
  search = {
    key = '<leader>sr',
    desc = 'Search and Replace',
  },
  searchCurrent = {
    key = '<leader>sc',
    desc = 'Search and Replace (Current File)',
  },
  close = {
    key = '<leader>ss',
    desc = 'Close GrugFar',
  },
  resume = {
    key = '<leader>sR',
    desc = 'Resume GrugFar',
  },
}
M.NvimTree.grugFar = {
  key = 'z',
  desc = 'Search and Replace',
}
M.Snacks.search = {
  grep = {
    key = '<leader>sg',
    desc = 'Grep',
  },
  resume = {
    key = '<leader>sp',
    desc = 'Resume Picker',
  },
}

-- code
M.Conform.format = {
  key = '<C-f>',
  desc = 'Format',
}
M.Cmp = {
  nextItem = {
    key = '<C-j>',
  },
  prevItem = {
    key = '<C-k>',
  },
  snipParamsNext = {
    key = '<C-l>',
  },
  snipParamsPrev = {
    key = '<C-h>',
  },
}
M.LspSaga = {
  prevDiagnostic = {
    key = '[d',
    desc = 'Prev Diagnostic',
  },
  nextDiagnostic = {
    key = ']d',
    desc = 'Next Diagnostic',
  },
  prevError = {
    key = '[e',
    desc = 'Prev Error',
  },
  nextError = {
    key = ']e',
    desc = 'Next Error',
  },
  prevWarning = {
    key = '[w',
    desc = 'Prev Warning',
  },
  nextWarning = {
    key = ']w',
    desc = 'Next Warning',
  },
  hoverDoc = {
    key = 'K',
    desc = 'Hover',
  },
  peekDefinition = {
    key = 'gd',
    desc = 'Peek Definition',
  },
  gotoDefinition = {
    key = 'gD',
    desc = 'Goto Definition',
  },
  peekTypeDefinition = {
    key = 'gy',
    desc = 'Peek Type Definition',
  },
  gotoTypeDefinition = {
    key = 'gY',
    desc = 'Goto Type Definition',
  },
  codeAction = {
    key = '<leader>ca',
    desc = 'Code Action',
  },
  outline = {
    key = '<leader>co',
    desc = 'Outline',
  },
  rename = {
    key = '<leader>cr',
    desc = 'Rename',
  },
  finder = {
    key = '<leader>cF',
    desc = 'Find',
  },
}
M.Snacks.code = {
  bufferDiagnostics = {
    key = '<leader>cd',
    desc = 'Diagnostics',
  },
}
M.Mason = {
  key = '<leader>cm',
  desc = 'Mason',
}

-- git
M.GitSigns = {
  nextHunk = {
    key = ']h',
    desc = 'Next Hunk',
  },
  prevHunk = {
    key = '[h',
    desc = 'Prev Hunk',
  },
  stageHunk = {
    key = '<leader>ghs',
    desc = 'Stage Hunk',
  },
  resetHunk = {
    key = '<leader>ghr',
    desc = 'Reset Hunk',
  },
  undoStageHunk = {
    key = '<leader>ghu',
    desc = 'Undo Stage Hunk',
  },
  previewHunk = {
    key = '<leader>ghp',
    desc = 'Preview Hunk',
  },
  selectHunk = {
    key = 'ih',
    desc = 'Select Hunk',
  },
}
M.DiffView = {
  openDiff = {
    key = '<leader>gd',
    desc = 'Open Diff',
  },
  currentFileHistory = {
    key = '<leader>gf',
    desc = 'File History (Current File)',
  },
  projectFileHistory = {
    key = '<leader>gF',
    desc = 'File History (Current Project)',
  },
}
M.Snacks.git = {
  lazygit = {
    key = '<leader>gg',
    desc = 'Lazygit',
  },
  browser = {
    key = '<leader>gb',
    desc = 'Git Browser',
  },
}
M.Neogit = {
  open = {
    key = '<leader>gn',
    desc = 'Neogit',
  },
}

-- mark
M.Harpoon = {
  add = {
    key = '<leader>mm',
    desc = 'Add Mark',
  },
  list = {
    key = '<leader>ml',
    desc = 'List Marks',
  },
  clear = {
    key = '<leader>mc',
    desc = 'Clear Marks',
  },
}

M.Snacks.terminal = {
  open = {
    key = '<leader>t',
    desc = 'Open Terminal',
  },
}

-- ui toggle
M.Snacks.uiToggle = {
  backgroundTransparent = {
    key = '<leader>ut',
    desc = 'Background Transparent',
  },
  darkMode = {
    key = '<leader>ud',
    desc = 'DarkMode',
  },
  inlayHint = {
    key = '<leader>uh',
    desc = 'Inlay Hint',
  },
  virtualText = {
    key = '<leader>uv',
    desc = 'Virtual Text',
  },
  lspUnderline = {
    key = '<leader>ul',
    desc = 'Lsp Underline',
  },
}
