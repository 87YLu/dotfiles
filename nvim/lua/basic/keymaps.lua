vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local utils = require('utils')

local keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- 窗口分屏
keyset('n', 'sv', function()
  if utils.current_file.type() ~= 'neo-tree' then
    vim.cmd(':vsp')
  end
end, { desc = 'split vertically' })
keyset('n', 'sh', function()
  if utils.current_file.type() ~= 'neo-tree' then
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
keyset('t', '<C-h>', [[ <C-\><C-N><C-w>h ]], { desc = 'jump to the left window' })
keyset('t', '<C-j>', [[ <C-\><C-N><C-w>j ]], { desc = 'jump to the lower window' })
keyset('t', '<C-k>', [[ <C-\><C-N><C-w>k ]], { desc = 'jump to the upper window' })
keyset('t', '<C-l>', [[ <C-\><C-N><C-w>l ]], { desc = 'jump to the right window' })

-- 窗口调整大小
keyset('n', '<C-,>', ':vertical resize -20<CR>', { desc = 'horizontal narrowing window' })
keyset('n', '<C-.>', ':vertical resize +20<CR>', { desc = 'horizontal zoom window' })
keyset('n', '<C-;>', ':resize -10<CR>', { desc = 'vertical narrowing window' })
keyset('n', "<C-'>", ':resize +10<CR>', { desc = 'vertical zoom window' })
keyset('n', '<C-=>', '<C-w>=', { desc = 'equal all windows' })

-- visual 模式设置
keyset('v', '<', '<gv', { desc = 'indent to the left' })
keyset('v', '>', '>gv', { desc = 'indent to the right' })
keyset('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move the selected content up' })
keyset('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'move the selected content down' })
keyset('v', 'p', '"_dP') -- 在visual 模式里粘贴不要复制
keyset('v', 'jk', '<Esc>', { desc = 'exit visual mode' })
keyset('v', 'q', '<Esc>', { desc = 'exit visual mode' })
keyset('v', 'h', '0')
keyset('v', 'l', '$')

-- normal 模式设置
keyset('n', 'h', '0')
keyset('n', 'l', '$')
keyset('n', '<C-j>', '10j', { desc = 'cursor moves down 10 lines' })
keyset('n', '<C-k>', '10k', { desc = 'cursor moves up 10 lines' })
keyset('n', 'q', ':q<CR>', { desc = 'exit' })
keyset('n', 'q\\', ':q!<CR>', { desc = 'forced exit' })
keyset('n', '<leader><leader>', ':silent! w<CR>', { desc = 'save' })
keyset('n', 'cp', function()
  local path = utils.cwd()
  vim.fn.setreg('+', path)
  vim.fn.setreg('"', path)
  vim.notify(string.format('Copied %s to system clipboard!', path))
end, { desc = 'copy project directory path' })

-- insert 模式设置
keyset('i', '<C-a>', '<ESC>I', { desc = 'cursor move to the beginning of the line' })
keyset('i', '<C-e>', '<ESC>A', { desc = 'cursor move to the ending of the line' })

-- comment
keyset({ 'i', 'n' }, '<C-\\>', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = 'toggle comment' })
keyset({ 'i', 'n' }, '<A-\\>', function()
  require('Comment.api').toggle.blockwise.current()
end, { desc = 'toggle comment' })
keyset('v', '<C-\\>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'toggle comment' })

-- plugin about code action start
-- ale
keyset('n', '<leader>f', ':ALEFix<CR>', { desc = 'format code' })
-- toggleterm
keyset('n', '<C-A-n>', '<CMD>lua _G.code_runner_toggle()<CR>', { desc = 'run code' })
-- plugin about code action end

-- plugin bufferline start
keyset('n', '<A-h>', ':BufferLineCyclePrev<CR>', { desc = 'move to the previous tab' })
keyset('n', '<A-l>', ':BufferLineCycleNext<CR>', { desc = 'move to the next tab' })
keyset('n', '<C-w>', ':Bdelete!<CR>', { desc = 'close current tab' })
keyset('n', '<leader>br', ':BufferLineCloseRight<CR>', { desc = 'close the right tab' })
keyset('n', '<leader>bl', ':BufferLineCloseLeft<CR>', { desc = 'close the left tab' })
keyset('n', '<leader>bp', ':BufferLinePickClose<CR>', { desc = 'pick tab to close' })
-- plugin bufferline end

-- plugin neo-tree start
keyset('n', '<A-m>', function()
  _G.toggle_neo_tree()
end, { desc = 'toggle neotree' })

keyset('n', '<leader>c', function()
  _G.focus_current_file()
end, { desc = 'toggle neotree' })
-- plugin neo-tree end

-- plugin telescope start
keyset('n', '<C-p>', function()
  _G.resume_telescope({ action = 'find_files' })
end, { desc = 'find files' })
keyset('n', '<C-f>', function()
  _G.resume_telescope()
end, { desc = 'global search' })
keyset('n', '<A-f>', function()
  _G.resume_telescope({ path = utils.current_file.path() })
end, { desc = 'search in current file' })
keyset('n', '<leader>m', function()
  vim.g.is_telescope_pickers_opening = true
  require('telescope.builtin').pickers()
end, { desc = 'list telescope pickers' })
-- plugin telescope end

-- plugin session manager start
keyset('n', '<leader>p', ':SessionManager load_session<CR>', { desc = 'load session' })
-- plugin session manager end

-- plugin coc start
-- tab/cr 选中代码
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keyset('i', '<c-o>', 'coc#refresh()', { desc = 'trigger complement', silent = true, expr = true })

local coc_keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

coc_keyset('n', '[g', '<Plug>(coc-diagnostic-prev)', { desc = 'find the previous question' })
coc_keyset('n', ']g', '<Plug>(coc-diagnostic-next)', { desc = 'find the next question' })
coc_keyset('n', 'gi', '<Plug>(coc-implementation)', { desc = 'list todos' }) -- 待验证
coc_keyset('n', 'gr', '<Plug>(coc-references)', { desc = 'list the references' })
coc_keyset('n', 'K', '<CMD>lua _G.show_docs()<CR>', { desc = 'show doc' })
coc_keyset('n', '<leader>rn', '<Plug>(coc-rename)', { desc = 'rename' })
coc_keyset({ 'n', 'x' }, '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { desc = 'refactor code actions' })
coc_keyset('n', '<leader>ff', '<Plug>(coc-fix-current)', { desc = 'quick fix' })
coc_keyset('n', '<leader>t', '<Plug>(coc-translator-p)', { desc = 'translate' })
coc_keyset('v', '<leader>t', '<Plug>(coc-translator-pv)', { desc = 'translate' })
local cursor_layout = {
  layout_config = {
    width = 0.6,
    height = 0.4,
  },
}
keyset('n', '<leader>d', function()
  require('telescope').extensions.coc.diagnostics(require('telescope.themes').get_ivy())
end, { desc = 'show current file diagnostics' })
keyset('n', '<leader>D', function()
  require('telescope').extensions.coc.workspace_diagnostics(require('telescope.themes').get_ivy())
end, { desc = 'show workspace diagnostics' })
keyset('n', 'gd', function()
  require('telescope').extensions.coc.definitions(require('telescope.themes').get_cursor(cursor_layout))
end, { desc = 'show definition' })
keyset('n', 'gy', function()
  require('telescope').extensions.coc.type_definitions(require('telescope.themes').get_cursor(cursor_layout))
end, { desc = 'show type definition' })
keyset('n', '<leader>t', function()
  require('telescope').extensions.coc.document_symbols({})
end, { desc = 'show document symbols' })

-- plugin coc end

-- plugin about git start
-- gitsigns
keyset('n', '[c', ':Gitsigns prev_hunk<CR>', { desc = 'prev hunk' })
keyset('n', ']c', ':Gitsigns next_hunk<CR>', { desc = 'next hunk' })
keyset('n', 'hv', ':Gitsigns preview_hunk<CR>', { desc = 'hunk view' })
keyset('n', 'hr', ':Gitsigns reset_hunk<CR>', { desc = 'hunk reset' })
keyset('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'hunk stage' })
keyset('n', '<leader>fs', ':Gitsigns stage_buffer<CR>', { desc = 'file stage' })
-- map('n', '<leader>hu', gs.undo_stage_hunk)
-- map('n', '<leader>hb', function() gs.blame_line { full = true } end)
-- map('n', '<leader>hD', function() gs.diffthis('~') end)
-- map('n', '<leader>td', gs.toggle_deleted)
-- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
-- diffview
keyset('n', '<leader>,', '<CMD>lua _G.view_file_diff()<CR>', { desc = 'view file diff' })
keyset('n', '<leader>.', '<CMD>lua _G.view_file_history()<CR>', { desc = 'view file history' })
keyset('n', '<leader>/', '<CMD>lua _G.view_git_history()<CR>', { desc = 'view git history' })
-- lazygit
keyset('n', '<leader>g', '<CMD>lua _G.lazygit_toggle()<CR>', { desc = 'open lazygit' })
-- plugin about git end
