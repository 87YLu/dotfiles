local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

if not vim.g.vscode then
  -- 文件更改时检查是否需要重新加载
  vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup('checktime'),
    command = 'checktime',
  })

  -- 拖动窗口时重设分页大小
  vim.api.nvim_create_autocmd({ 'VimResized' }, {
    group = augroup('resize_splits'),
    callback = function()
      vim.cmd('tabdo wincmd =')
    end,
  })

  -- 回到上次的光标位置
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('last_loc'),
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  -- 自动跳转会英文输入法
  vim.api.nvim_create_autocmd('InsertLeave', {
    pattern = '',
    callback = function()
      require('native.utils.input_mode').to_en()
    end,
  })

  -- 高亮复制内容
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- 映射 ttml 为 html
  vim.api.nvim_command('autocmd BufNewFile,BufRead *.ttml setfiletype ttml')
end
