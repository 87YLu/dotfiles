local opt = vim.opt
local g = vim.g

if not vim.g.vscode then
  -- neotree
  vim.g.auto_open_explorer = true
  vim.g.neotree_position = 'left'

  vim.g.colorscheme = g.colorscheme or 'catppuccin'
  vim.g.transparent_background = (g.transparent_background == nil) and true or g.transparent_background

  -- 使用增强状态栏插件后不再需要 vim 的模式提示
  opt.showmode = false
end

-- utf8
opt.encoding = 'UTF-8'
opt.fileencoding = 'utf-8'
-- 使光标一直在屏幕中间
opt.scrolloff = 999
opt.sidescrolloff = 999
-- 使用相对行号
opt.number = true
opt.relativenumber = true
-- 高亮所在行
opt.cursorline = true
-- 显示左侧图标指示列
opt.signcolumn = 'yes'
-- 右侧参考线，超过表示代码太长了，考虑换行
opt.colorcolumn = '120'
-- 缩进2个空格等于一个Tab
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
-- >> << 时移动长度
opt.shiftwidth = 2
-- 空格替代tab
opt.expandtab = true
-- 新行对齐当前行
opt.autoindent = true
opt.smartindent = true
-- 搜索大小写不敏感，除非包含大写
opt.ignorecase = true
opt.smartcase = true
-- 搜索不要高亮
opt.hlsearch = false
-- 边输入边搜索
opt.incsearch = true
-- 命令行高为1
opt.cmdheight = 0
-- 当文件被外部程序修改时，自动加载
opt.autoread = true
-- 禁止折行
opt.wrap = false
-- 光标在行首尾时<Left><Right>可以跳到下一行
opt.whichwrap = '<,>,[,]'
-- 允许隐藏被修改过的buffer
opt.hidden = true
-- 鼠标支持
opt.mouse = 'a'
-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false
-- smaller updatetime
opt.updatetime = 300
-- 设置 timeoutlen 为等待键盘快捷键连击时间500毫秒，可根据需要设置
opt.timeoutlen = 500
-- split window 从下边和右边出现
opt.splitbelow = true
opt.splitright = true
-- 自动补全不自动选中
opt.completeopt = 'menu,menuone,noselect,noinsert'
-- 样式
opt.termguicolors = true
-- 不可见字符的显示，这里只把空格显示为一个点
opt.list = true
opt.listchars = 'space:·'
-- 补全增强
opt.wildmenu = true
opt.shortmess:append({ W = true, I = true, c = true })
-- 补全最多显示10行
opt.pumheight = 10
-- 永远显示 tabline
opt.showtabline = 2

-- 系统剪贴板
opt.clipboard = 'unnamedplus'
opt.spell = false
-- 折叠
opt.foldmethod = 'indent'
opt.foldenable = true
opt.foldlevelstart = 99
opt.foldlevel = 99
