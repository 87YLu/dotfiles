vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local current_file = require('utils.current_file')
local common_utils = require('utils.common')
local global_config_utils = require('utils.global_config')

local keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local plugin_keys = {}

-- 窗口分屏
keyset('n', 'sv', function()
  if current_file.type() ~= 'neo-tree' then
    vim.cmd(':vsp')
  end
end, { desc = 'split vertically' })
keyset('n', 'sh', function()
  if current_file.type() ~= 'neo-tree' then
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
keyset('n', '<A-,>', ':vertical resize -20<CR>', { desc = 'horizontal narrowing window' })
keyset('n', '<A-.>', ':vertical resize +20<CR>', { desc = 'horizontal zoom window' })
keyset('n', '<A-;>', ':resize -10<CR>', { desc = 'vertical narrowing window' })
keyset('n', "<A-'>", ':resize +10<CR>', { desc = 'vertical zoom window' })
keyset('n', '<A-=>', '<C-w>=', { desc = 'equal all windows' })

-- visual 模式设置
keyset('v', '<Esc>', '<Esc><Esc>')
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
  local path = common_utils.cwd()
  common_utils.copy(path)
end, { desc = 'copy project directory path' })

-- insert 模式设置
keyset('i', '<Esc>', function()
  vim.cmd('stopinsert')
end)
keyset('i', '<C-a>', '<ESC>I', { desc = 'cursor move to the beginning of the line' })
keyset('i', '<C-e>', '<ESC>A', { desc = 'cursor move to the ending of the line' })

plugin_keys.comment = (function()
  keyset({ 'i', 'n' }, '<C-\\>', function()
    require('Comment.api').toggle.linewise.current()
  end, { desc = 'toggle comment' })
  keyset({ 'i', 'n' }, '<A-\\>', function()
    require('Comment.api').toggle.blockwise.current()
  end, { desc = 'toggle comment' })
  keyset('v', '<C-\\>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'toggle comment' })
end)()

plugin_keys.conform = (function()
  keyset('n', '<leader>f', function()
    require('conform').format()
  end, { desc = 'format code' })
end)()

plugin_keys.toggleterm = (function()
  keyset('n', '<C-A-n>', '<CMD>lua _G.code_runner_toggle()<CR>', { desc = 'run code' })
  keyset('n', '<leader>g', '<CMD>lua _G.lazygit_toggle()<CR>', { desc = 'open lazygit' })
end)()

plugin_keys.bufferline = (function()
  keyset('n', '<A-h>', ':BufferLineCyclePrev<CR>', { desc = 'move to the previous tab' })
  keyset('n', '<A-l>', ':BufferLineCycleNext<CR>', { desc = 'move to the next tab' })
  keyset('n', '<A-w>', ':Bdelete!<CR>', { desc = 'close current tab' })
  keyset('n', '<A-q>', ':BufferLineCloseOthers<CR>', { desc = 'close other tab' })
  keyset('n', '<leader>br', ':BufferLineCloseRight<CR>', { desc = 'close the right tab' })
  keyset('n', '<leader>bl', ':BufferLineCloseLeft<CR>', { desc = 'close the left tab' })
  keyset('n', '<leader>bp', ':BufferLinePickClose<CR>', { desc = 'pick tab to close' })
end)()

plugin_keys.neo_tree = (function()
  keyset('n', '<A-m>', function()
    _G.toggle_neo_tree()
  end, { desc = 'toggle neotree' })
end)()

plugin_keys.telescope = (function()
  keyset('n', '<C-p>', function()
    _G.resume_telescope({ action = 'find_files' })
  end, { desc = 'find files' })
  keyset('n', '<C-f>', function()
    _G.resume_telescope()
  end, { desc = 'global search' })
  keyset('n', '<A-f>', function()
    _G.resume_telescope({ path = current_file.path() })
  end, { desc = 'search in current file' })
  keyset('n', '<leader>l', function()
    require('telescope.builtin').pickers()
  end, { desc = 'list telescope pickers' })
  keyset('n', '<leader>o', function()
    require('telescope.builtin').oldfiles({ cwd_only = true })
  end, { desc = 'list recently files' })
  keyset('n', '<leader>c', function()
    _G.open_colorscheme_switcher()
  end, { desc = 'change colorscheme' })
  keyset('n', '<leader>C', function()
    _G.open_transparent_background_switcher()
  end, { desc = 'change the background transparency' })
end)()

plugin_keys.session_manager = (function()
  keyset('n', '<leader>p', ':SessionManager load_session<CR>', { desc = 'load session' })
end)()

plugin_keys.harpoon = (function()
  keyset('n', '<leader>m', function()
    require('telescope').extensions.harpoon.marks()
  end, { desc = 'show marks' })
  keyset('n', '<leader>am', function()
    require('harpoon.mark').add_file()
    vim.notify('add mark')
  end, { desc = 'add mark' })
  keyset('n', '<leader>rm', function()
    require('harpoon.mark').rm_file()
    vim.notify('remove mark')
  end, { desc = 'remove mark' })
  keyset('n', '<leader>cm', function()
    require('harpoon.mark').clear_all()
    vim.notify('clear all marks')
  end, { desc = 'clear all marks' })
end)()

plugin_keys.hbac = (function()
  keyset('n', '<leader>\\', function()
    require('hbac').toggle_pin()
  end, { desc = 'toggle pin' })
  keyset('n', '<leader>|', function()
    require('hbac').toggle_autoclose()
    global_config_utils.set_global_config('hbac_autoclose', require('hbac.state').autoclose_enabled)
  end, { desc = 'toggle autoclose' })
end)()

plugin_keys.coc = (function()
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

  -- coc-git
  keyset('n', '[c', '<Plug>(coc-git-prevchunk)')
  keyset('n', ']c', '<Plug>(coc-git-nextchunk)')
  keyset('n', '<leader>hv', '<Plug>(coc-git-chunkinfo)')
end)()

plugin_keys.diffview = (function()
  keyset('n', '<leader>,', '<CMD>lua _G.view_file_diff()<CR>', { desc = 'view file diff' })
  keyset('n', '<leader>.', '<CMD>lua _G.view_file_history()<CR>', { desc = 'view file history' })
  keyset('n', '<leader>/', '<CMD>lua _G.view_git_history()<CR>', { desc = 'view git history' })
end)()

return plugin_keys
