local M = {}

local support_type = {
  'png',
  'jpg',
  'jpeg',
  'gif',
}

-- brew install imagemagick
M.support = (vim.fn.executable('magick') == 1) and (vim.env.KITTY_WINDOW_ID ~= nil)

if M.support then
  local function is_image_file(filename)
    local image_extensions = {}

    for _, v in ipairs(support_type) do
      image_extensions[v] = true
    end

    if not filename then
      return false
    end

    local ext = filename:match('%.([^.]+)$')
    return ext and image_extensions[ext:lower()] or false
  end

  vim.api.nvim_create_autocmd({ 'BufLeave', 'BufHidden' }, {
    callback = function(args)
      local bufname = vim.api.nvim_buf_get_name(args.buf)

      if is_image_file(bufname) then
        vim.schedule(function()
          local windows = vim.fn.win_findbuf(args.buf)
          if #windows == 0 then
            Snacks.bufdelete.delete(args.buf)
          end
        end)
      end
    end,
    desc = 'Auto close image buffers',
  })
end

M.snack_image = {
  enabled = M.support,
  formats = support_type,
}

return M
