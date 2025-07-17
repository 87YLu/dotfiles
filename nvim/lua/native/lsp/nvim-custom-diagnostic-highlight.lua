-- https://github.com/Kasama/nvim-custom-diagnostic-highlight
-- 置灰没有使用到的代码
return {
  'Kasama/nvim-custom-diagnostic-highlight',
  event = 'LSPAttach',
  config = function()
    require('nvim-custom-diagnostic-highlight').setup({
      patterns_override = {
        '%sunused',
        '^unused',
        'not used',
        'never used',
        'not read',
        'never read',
        'empty block',
        'not accessed',
        '未读取',
        '未使用',
      },
    })
  end,
}
