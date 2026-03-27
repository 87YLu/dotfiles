---@class UtilsImage
---@field support boolean
---@field snack_image table
local M = {}

local support_type = {
  'png',
  'jpg',
  'jpeg',
  'gif',
}
local image_extensions = {}

for _, ext in ipairs(support_type) do
  image_extensions[ext] = true
end

-- brew install imagemagick
M.support = (vim.fn.executable('magick') == 1) and vim.g.kitty

if M.support then
  local function is_image_file(filename)
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
