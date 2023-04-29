vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local plugin_keys = {}

local keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- 窗口分屏
keyset('n', 's', '')
keyset('n', 'sv', ':vsp<CR>', { desc = 'split vertically' })
keyset('n', 'sh', ':sp<CR>', { desc = 'split horizontally' })
keyset('n', 'cc', '<C-w>c', { desc = 'close current window' })
keyset('n', 'co', '<C-w>o', { desc = 'close other windows' })

-- 窗口跳转
keyset('n', '<A-h>', '<C-w>h', { desc = 'jump to the left window' })
keyset('n', '<A-j>', '<C-w>j', { desc = 'jump to the lower window' })
keyset('n', '<A-k>', '<C-w>k', { desc = 'jump to the upper window' })
keyset('n', '<A-l>', '<C-w>l', { desc = 'jump to the right window' })
keyset('t', '<A-h>', [[ <C-\><C-N><C-w>h ]], { desc = 'jump to the left window' })
keyset('t', '<A-j>', [[ <C-\><C-N><C-w>j ]], { desc = 'jump to the lower window' })
keyset('t', '<A-k>', [[ <C-\><C-N><C-w>k ]], { desc = 'jump to the upper window' })
keyset('t', '<A-l>', [[ <C-\><C-N><C-w>l ]], { desc = 'jump to the right window' })

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
keyset('v', 'p', "'_dP") -- 在visual 模式里粘贴不要复制
keyset('v', 'jk', '<Esc>', { desc = 'exit visual mode' })

-- normal 模式设置
keyset('n', '<C-j>', '10j', { desc = 'cursor moves down 10 lines' })
keyset('n', '<C-k>', '10k', { desc = 'cursor moves up 10 lines' })
keyset('n', 'q', ':q<CR>', { desc = 'exit' })
keyset('n', 'q\\', ':q!<CR>', { desc = 'forced exit' })

-- insert 模式下，跳到行首行尾
keyset('i', '<C-a>', '<ESC>I', { desc = 'cursor move to the beginning of the line' })
keyset('i', '<C-e>', '<ESC>A', { desc = 'cursor move to the ending of the line' })

-- plugin toggleterm start
keyset('n', '<leader>t', ':ToggleTerm<CR>', { desc = 'open terminal horizontally' })
keyset('n', '<leader>vt', ':ToggleTerm direction=vertical size=40<CR>', { desc = 'open terminal vertically' })
keyset('n', '<leader>at', ':ToggleTermToggleAll<CR>', { desc = 'open all terminals' })
-- plugin toggleterm end

-- plugin about code action start
-- ale
keyset('n', '<leader>f', ':ALEFix<CR>', { desc = 'format code' })
-- toggleterm
keyset('n', '<C-A-n>', '<CMD>lua _G.code_runner_toggle()<CR>', { desc = 'run code' })
-- plugin about code action end

-- plugin bufferline start
keyset('n', '<C-h>', ':BufferLineCyclePrev<CR>', { desc = 'move to the previous tab' })
keyset('n', '<C-l>', ':BufferLineCycleNext<CR>', { desc = 'move to the next tab' })
keyset('n', '<C-w>', ':Bdelete!<CR>', { desc = 'close current tab' })
keyset('n', '<leader>br', ':BufferLineCloseRight<CR>', { desc = 'close the right tab' })
keyset('n', '<leader>bl', ':BufferLineCloseLeft<CR>', { desc = 'close the left tab' })
keyset('n', '<leader>bp', ':BufferLinePickClose<CR>', { desc = 'pick tab to close' })
-- plugin bufferline end

-- plugin nvim-tree start
keyset('n', '<A-m>', ':NvimTreeToggle<CR>', { desc = 'toggle file explorer' })
plugin_keys.nvimtree_keys = function(api, bufnr)
  local nvimtree_keyset = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.noremap = opts.noremap ~= false
    opts.silent = opts.silent ~= false
    opts.nowait = opts.nowait ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  nvimtree_keyset('n', '<CR>', api.node.open.edit, { desc = 'open' })
  nvimtree_keyset('n', 'o', api.node.open.edit, { desc = 'open' })
  nvimtree_keyset('n', '<2-LeftMouse>', api.node.open.edit, { desc = 'open' })
  nvimtree_keyset('n', 'v', api.node.open.vertical, { desc = 'open: vertical split' })
  nvimtree_keyset('n', 'h', api.node.open.horizontal, { desc = 'open: horizontal split' })
  nvimtree_keyset('n', '.', api.tree.toggle_hidden_filter, { desc = 'toggle dotfiles' })
  nvimtree_keyset('n', '<F5>', api.tree.reload, { desc = 'refresh' })
  nvimtree_keyset('n', 'a', api.fs.create, { desc = 'create' })
  nvimtree_keyset('n', 'd', api.fs.remove, { desc = 'delete' })
  nvimtree_keyset('n', 'r', api.fs.rename, { desc = 'rename' })
  nvimtree_keyset('n', 'x', api.fs.cut, { desc = 'cut' })
  nvimtree_keyset('n', 'c', api.fs.copy.node, { desc = 'copy' })
  nvimtree_keyset('n', 'p', api.fs.paste, { desc = 'paste' })
  nvimtree_keyset('n', 's', api.node.run.system, { desc = 'run System' })
end
-- plugin nvim-tree end

-- plugin telescope start
keyset('n', '<C-p>', ':Telescope find_files<CR>', { desc = 'find files' })
keyset('n', '<C-f>', ':Telescope live_grep<CR>', { desc = 'global search' })
plugin_keys.telescope_keys = {
  i = {
    ['<Down>'] = 'move_selection_next',
    ['<Up>'] = 'move_selection_previous',
    ['<C-c>'] = 'close',
    ['<C-u>'] = 'preview_scrolling_up',
    ['<C-d>'] = 'preview_scrolling_down',
  },
}
-- plugin telescope end

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
coc_keyset('n', 'gd', '<Plug>(coc-definition)', { desc = 'back to the definition position' })
coc_keyset('n', 'gy', '<Plug>(coc-type-definition)', { desc = 'go to type definition' })
coc_keyset('n', 'gi', '<Plug>(coc-implementation)', { desc = 'list todos' }) -- 待验证
coc_keyset('n', 'gr', '<Plug>(coc-references)', { desc = 'list the references' })
coc_keyset('n', 'K', '<CMD>lua _G.show_docs()<CR>', { desc = 'show doc' })
coc_keyset('n', '<leader>rn', '<Plug>(coc-rename)', { desc = 'rename' })
coc_keyset({ 'n', 'x' }, '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { desc = 'refactor code actions' })
coc_keyset({ 'n', 'x' }, '<C-s>', '<Plug>(coc-range-select)', { desc = 'range select' })

local coc_keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  opts.nowait = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

coc_keyset('n', '<space>o', ':<C-u>CocList outline<cr>', { desc = 'find symbol of current document' })
coc_keyset('n', '<space>s', ':<C-u>CocList -I symbols<cr>', { desc = 'search workspace symbols' })
coc_keyset('n', '<leader>qf', '<Plug>(coc-fix-current)', { desc = 'quick fix' })
coc_keyset('n', '<leader>cl', '<Plug>(coc-codelens-action)')
coc_keyset({ 'x', 'o' }, 'if', '<Plug>(coc-funcobj-i)')
coc_keyset({ 'x', 'o' }, 'af', '<Plug>(coc-funcobj-a)')
coc_keyset({ 'x', 'o' }, 'ic', '<Plug>(coc-classobj-i)')
coc_keyset({ 'x', 'o' }, 'ac', '<Plug>(coc-classobj-a)')

local coc_keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  opts.nowait = true
  opts.expr = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

coc_keyset('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"')
coc_keyset('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"')
coc_keyset('i', '<C-f>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"')
coc_keyset('i', '<C-b>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"')
coc_keyset('v', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"')
coc_keyset('v', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"')
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
keyset('n', 'dv', ':DiffviewOpen<CR>', { desc = 'view file diff' }) -- 跟 coc 插件冲突，打开时可能会报错但是不影响使用
keyset('n', 'df', ':DiffviewFileHistory %<CR>', { desc = 'view file history' })
keyset('n', 'dh', ':DiffviewFileHistory<CR>', { desc = 'view git history' })
keyset('n', 'dc', ':DiffviewClose<CR>', { desc = 'diffview close' })
-- lazygit
keyset('n', '<leader>g', '<CMD>lua _G.lazygit_toggle()<CR>', { desc = 'open lazygit' })
-- plugin about git end

return plugin_keys
