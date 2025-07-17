vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keyset = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.keyset = keyset

if not vim.g.vscode then
  -- 非 vscode
  local file_utils = require('native.utils.file')
  local common_utils = require('native.utils.common')

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

  keyset('n', 'cp', function()
    -- 复制当前 cwd
    common_utils.copy(common_utils.cwd())
  end, { desc = 'copy project directory path' })
else
  -- vscode
  local function step_movement()
    keyset(
      { 'n', 'x', 's' },
      'j',
      'v:count ? "j" : ":call VSCodeNotify(\'cursorDown\')<CR>"',
      { silent = true, nowait = true, noremap = true, expr = true }
    )

    keyset(
      { 'n', 'x', 's' },
      'k',
      'v:count ? "k" : ":call VSCodeNotify(\'cursorUp\')<CR>"',
      { silent = true, nowait = true, noremap = true, expr = true }
    )
  end

  vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter', 'BufWinEnter' }, {
    pattern = '*',
    callback = function()
      step_movement()
    end,
  })
end

-- visual 模式设置
keyset('v', '<', '<gv', { desc = 'indent to the left' })
keyset('v', '>', '>gv', { desc = 'indent to the right' })
keyset('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move the selected content up' })
keyset('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'move the selected content down' })
keyset('v', 'p', '"_dP') -- 在visual 模式里粘贴不要复制
keyset('v', 'H', '^')
keyset('v', 'L', '$')
keyset('v', 'jk', '<ESC>')

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
keyset('n', 'q', '', { desc = 'no action' })
keyset('n', 'q\\', ':q!<CR>', { desc = 'forced exit' })
keyset('n', '<C-w>', ':silent! w<CR>', { desc = 'save' })

-- insert 模式设置
keyset('i', '<Esc>', '<cmd>stopinsert<CR>')
keyset('i', '<C-a>', '<ESC>I', { desc = 'cursor move to the beginning of the line' })
keyset('i', '<C-e>', '<ESC>A', { desc = 'cursor move to the ending of the line' })
keyset('i', 'jk', '<ESC>')

-- 插件 -------------------------------------------------------

local plugin_keys = {}

plugin_keys.comment = {
  -- 单行注释
  toggle_line = '<C-\\>',
  -- 块级注释
  toggle_block = '<A-\\>',
}

plugin_keys.conform = {
  -- 格式化
  format = '<leader>f',
}

plugin_keys.toggleterm = {
  -- 运行代码
  run_code = '<C-A-n>',
  -- 打开/关闭 lazygit
  toggle_lazy_git = '<leader>g',
}

plugin_keys.bufferline = {
  -- 移动到左边的 tab
  prev_tab = '<A-h>',
  -- 移动到右边的 tab
  next_tab = '<A-l>',
  -- 关闭当前 tab
  close_tab = '<A-w>',
  -- 关闭其他 tab
  close_other_tab = '<A-q>',
  -- 关闭左边的 tab
  close_left_tab = '<leader>bl',
  -- 关闭右边的 tab
  close_right_tab = '<leader>br',
  -- 选择关闭
  pick_close = '<leader>bp',
}

plugin_keys.colorscheme = {
  -- 主题切换
  change_colorscheme = '<leader>c',
  -- 透明度切换
  change_transparency = '<leader>C',
}

plugin_keys.neo_tree = {
  -- 打开/关闭文件树
  toggle = '<A-m>',
}

plugin_keys.telescope = {
  -- 查找文件
  find_files = '<C-p>',
  -- 全局搜索
  global_search = '<C-f>',
  -- 搜索当前文件
  search_in_current_file = '<A-f>',
  -- 搜索历史
  list_pickers = '<leader>l',
  -- 最近文件
  list_recently_files = '<leader>o',
  -- 向下选择
  move_selection_next = '<C-j>',
  -- 向上选择
  move_selection_previous = '<C-k>',
  -- 关闭浮窗
  close = '<C-c>',
  -- 预览向上翻
  preview_scrolling_up = '<C-u>',
  -- 预览向下翻
  preview_scrolling_down = '<C-d>',
  -- 清除输入内容
  clear = '<C-r>',
}

plugin_keys.harpoon = {
  -- 浮窗打开书签列表
  show_marks = '<leader>m',
  -- 添加书签
  add_mark = '<leader>am',
  -- 删除书签
  remove_mark = '<leader>rm',
  -- 清空书签
  clear_marks = '<leader>cm',
}

plugin_keys.hbac = {
  -- 锁定/取消锁定当前 buffer
  toggle = '<leader>\\',
  --  开启/禁用自动关闭
  toggle_autoclose = '<leader>|',
}

plugin_keys.diffview = {
  -- diff 文件
  file_diff = '<leader>,',
  -- 文件历史
  file_history = '<leader>.',
  -- git 历史
  git_history = '<leader>/',
}

plugin_keys.treesj = {
  -- 代码收起/展开
  toggle = '.',
}

plugin_keys.gitsigns = {
  -- 上个变更
  prev_hunk = '[c',
  -- 下个变更
  next_hunk = ']c',
  -- 暂存本块更改
  stage_hunk = '<leader>hs',
  -- 撤销本块更改
  undo_hunk = '<leader>hu',
  -- 预览变更
  hunk_preview = '<leader>hp',
}

plugin_keys.lspsaga = {
  -- 上个错误
  diagnostic_jump_prev = '[d',
  -- 下个错误
  diagnostic_jump_next = ']d',
  -- 工作区错误
  workspace_diagnostics = '<leader>d',
  -- 大纲
  outline = '<A-M>',
  -- 浮窗打开定义
  peek_definition = 'gd',
  -- 跳转到定义
  goto_definition = 'gf',
  -- 浮窗打开文档
  hover_doc = 'K',
  -- 重命名
  rename = '<leader>rn',
  -- 代码操作
  code_action = '<leader>ca',
}

plugin_keys.codeium = {
  -- 应用建议
  accept_suggestion = '<C-]>',
  -- 清除建议
  clear_suggesstion = '<C-[>',
  -- 下个建议
  next_suggestion = '<A-]>',
  -- 上个建议
  prev_suggestion = '<A-[>',
}

plugin_keys.typescript_tools = {
  -- 去除没引用的变量, 排序引用
  typescript_action = '<leader>t',
}

plugin_keys.cmp = {
  -- 下个候选列表
  c_next = '<C-j>',
  -- 上个候选列表
  c_prev = '<C-k>',
  -- 下个片段参数
  p_next = '<C-l>',
  -- 上个片段参数
  p_prev = '<C-h>',
}

return plugin_keys
