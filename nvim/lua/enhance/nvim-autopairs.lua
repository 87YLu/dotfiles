-- https://github.com/windwp/nvim-autopairs
-- 自动配对引号，括号等
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup({ map_cr = true })

    -- https://github.com/windwp/nvim-autopairs/wiki/Completion-plugin
    _G.MUtils = {}
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
