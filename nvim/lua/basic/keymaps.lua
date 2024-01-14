vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local file_utils = require('utils.file')
local common_utils = require('utils.common')

local keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local plugin_keys = {}

-- 窗口分屏
keyset('n', 'sv', function()
  if file_utils.current_type() ~= 'neo-tree' then
    vim.cmd(':vsp')
  end
end, { desc = 'split vertically' })
keyset('n', 'sh', function()
  if file_utils.current_type() ~= 'neo-tree' then
    vim.cmd(':sp')
  end
end, { desc = 'split horizontally' })
keyset('n', 'cc', '<C-w>c', { desc = 'close current window' })
keyset('n', 'co', '<C-w>o', { desc = 'close other windows' })

-- 窗口跳转
keyset('n', '<C-h>', '<C-w>h', { desc = 'jump to the left window' })
keyset('n', '<C-j>', '<C-w>j', { desc = 'jump to the lower window' })
keyset('n', '<C-k>', '<C-w>k', { desc = 'jump to the upper window' })
keyset('n', '<C-l>', '<C-w>l', { desc = 'jump to the right window' })

-- 窗口调整大小
keyset('n', '<A-,>', ':vertical resize -20<CR>', { desc = 'horizontal narrowing window' })
keyset('n', '<A-.>', ':vertical resize +20<CR>', { desc = 'horizontal zoom window' })
keyset('n', '<A-;>', ':resize -10<CR>', { desc = 'vertical narrowing window' })
keyset('n', "<A-'>", ':resize +10<CR>', { desc = 'vertical zoom window' })
keyset('n', '<A-=>', '<C-w>=', { desc = 'equal all windows' })

-- visual 模式设置
keyset('v', '<', '<gv', { desc = 'indent to the left' })
keyset('v', '>', '>gv', { desc = 'indent to the right' })
keyset('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move the selected content up' })
keyset('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'move the selected content down' })
keyset('v', 'p', '"_dP') -- 在visual 模式里粘贴不要复制
keyset('v', 'H', '^')
keyset('v', 'L', '$')

-- normal 模式设置
keyset('n', 'H', '^')
keyset('n', 'L', '$')
keyset('n', 'dH', 'd^')
keyset('n', 'dL', 'd$')
keyset('n', 'yy', function()
  -- 单次按 yy 时不复制空格和换行
  if vim.v.count > 1 then
    vim.cmd('normal! ' .. vim.v.count .. 'yy')
  else
    vim.cmd('let @l = line(".") | let @c = col(".")')
    vim.cmd('normal! ^y$')
    vim.cmd('call cursor(@l, @c)')
  end
end)
keyset('n', '<C-j>', '10j', { desc = 'cursor moves down 10 lines' })
keyset('n', '<C-k>', '10k', { desc = 'cursor moves up 10 lines' })
keyset('n', 'q', ':q<CR>', { desc = 'exit' })
keyset('n', 'q\\', ':q!<CR>', { desc = 'forced exit' })
keyset('n', '<C-w>', ':silent! w<CR>', { desc = 'save' })
keyset('n', 'cp', function()
  -- 复制当前 cwd
  local path = common_utils.cwd()
  common_utils.copy(path)
end, { desc = 'copy project directory path' })

-- insert 模式设置
keyset('i', '<Esc>', '<cmd>stopinsert<CR>')
keyset('i', '<C-a>', '<ESC>I', { desc = 'cursor move to the beginning of the line' })
keyset('i', '<C-e>', '<ESC>A', { desc = 'cursor move to the ending of the line' })

plugin_keys.comment = function()
  keyset({ 'i', 'n' }, '<C-\\>', function()
    require('Comment.api').toggle.linewise.current()
  end, { desc = 'toggle comment' })
  keyset({ 'i', 'n' }, '<A-\\>', function()
    require('Comment.api').toggle.blockwise.current()
  end, { desc = 'toggle comment' })
  keyset('v', '<C-\\>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'toggle comment' })
end

plugin_keys.conform = function(format)
  keyset('n', '<leader>f', format, { desc = 'format code' })
end

plugin_keys.toggleterm = function(run_code, toggle_lazygit)
  keyset('n', '<C-A-n>', run_code, { desc = 'run code' })
  keyset('n', '<leader>g', toggle_lazygit, { desc = 'open lazygit' })
end

plugin_keys.bufferline = function()
  keyset('n', '<A-h>', ':BufferLineCyclePrev<CR>', { desc = 'move to the previous tab' })
  keyset('n', '<A-l>', ':BufferLineCycleNext<CR>', { desc = 'move to the next tab' })
  keyset('n', '<A-w>', ':Bdelete!<CR>', { desc = 'close current tab' })
  keyset('n', '<A-q>', ':BufferLineCloseOthers<CR>', { desc = 'close other tab' })
  keyset('n', '<leader>br', ':BufferLineCloseRight<CR>', { desc = 'close the right tab' })
  keyset('n', '<leader>bl', ':BufferLineCloseLeft<CR>', { desc = 'close the left tab' })
  keyset('n', '<leader>bp', ':BufferLinePickClose<CR>', { desc = 'pick tab to close' })
end

plugin_keys.colorscheme = function(change_colorscheme, change_transparency)
  keyset('n', '<leader>c', change_colorscheme, { desc = 'change colorscheme' })
  keyset('n', '<leader>C', change_transparency, { desc = 'change the background transparency' })
end

plugin_keys.neo_tree = function(toggle)
  keyset('n', '<A-m>', toggle, { desc = 'toggle neotree' })
end

plugin_keys.telescope = function(find_files, global_search, search_in_current_file, list_pickers, list_recently_files)
  keyset('n', '<C-p>', find_files, { desc = 'find files' })
  keyset('n', '<C-f>', global_search, { desc = 'global search' })
  keyset('n', '<A-f>', search_in_current_file, { desc = 'search in current file' })
  keyset('n', '<leader>l', list_pickers, { desc = 'list telescope pickers' })
  keyset('n', '<leader>o', list_recently_files, { desc = 'list recently files' })
end

plugin_keys.session_manager = function(load_session)
  keyset('n', '<leader>p', load_session, { desc = 'load session' })
end

plugin_keys.harpoon = function(show_marks, add_mark, remove_mark, clear_marks)
  keyset('n', '<leader>m', show_marks, { desc = 'show marks' })
  keyset('n', '<leader>am', add_mark, { desc = 'add mark' })
  keyset('n', '<leader>rm', remove_mark, { desc = 'remove mark' })
  keyset('n', '<leader>cm', clear_marks, { desc = 'clear all marks' })
end

plugin_keys.hbac = function(toggle_pin, toggle_autoclose)
  keyset('n', '<leader>\\', toggle_pin, { desc = 'toggle pin' })
  keyset('n', '<leader>|', toggle_autoclose, { desc = 'toggle autoclose' })
end

plugin_keys.diffview = function(view_file_diff, view_file_history, view_git_history)
  keyset('n', '<leader>,', view_file_diff, { desc = 'view file diff' })
  keyset('n', '<leader>.', view_file_history, { desc = 'view file history' })
  keyset('n', '<leader>/', view_git_history, { desc = 'view git history' })
end

plugin_keys.treesj = function(toggle)
  keyset('n', '.', toggle)
end

plugin_keys.gitsigns = function(map, gs)
  map('n', '[c', function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'prev hunk' })

  map('n', ']c', function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'next hunk' })
  map('n', '<leader>hs', gs.stage_hunk, { desc = 'stage hunk' })
  map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo hunk' })
  map('n', '<leader>hp', gs.preview_hunk, { desc = 'hunk preview' })
end

plugin_keys.lspsaga = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      local opts = { buffer = ev.buf }

      keyset('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
      keyset('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
      keyset('n', '<leader>d', '<cmd>Lspsaga show_workspace_diagnostics ++float<CR>', opts)
      keyset('n', '<A-M>', '<cmd>Lspsaga outline<CR>', opts)
      keyset('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', opts)
      keyset('n', 'gf', '<cmd>Lspsaga goto_definition<CR>', opts)
      keyset('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
      keyset('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)
      keyset({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
      keyset({ 'n', 't' }, '<c-d>', '<cmd>Lspsaga term_toggle<CR>', opts)
    end,
  })
end

plugin_keys.codeium = function()
  keyset('i', '<C-]>', 'codeium#Accept()', { expr = true, silent = true })
  keyset('i', '<C-[>', 'codeium#Clear()', { expr = true, silent = true })
  keyset('i', '<A-]>', function()
    return vim.fn['codeium#CycleCompletions'](1)
  end, { expr = true, silent = true })
  keyset('i', '<A-[>', function()
    return vim.fn['codeium#CycleCompletions'](-1)
  end, { expr = true, silent = true })
end

plugin_keys.typescript_tools = function()
  keyset('n', '<leader>t', function()
    if file_utils.is_current_in_types({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) then
      vim.cmd('TSToolsRemoveUnused sync')
      vim.cmd('TSToolsAddMissingImports sync')
      vim.cmd('TSToolsOrganizeImports sync')
    end
  end, { desc = 'typescript action' })
end

return plugin_keys
