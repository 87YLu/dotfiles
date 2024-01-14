-- https://github.com/lewis6991/gitsigns.nvim
return {
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter',
  config = function()
    require('gitsigns').setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        require('basic.keymaps').gitsigns(map, gs)
      end,
    })
  end,
}
