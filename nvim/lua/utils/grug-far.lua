local M = {}
local instanceName = 'instanceName'

local function open_callback()
  vim.cmd('wincmd L')
  vim.cmd('vertical resize ' .. M.get_width())
end

M.get_width = function()
  return Utils.NvimConfig.get('grug_far_width', 80)
end

M.set_width = function(width)
  Utils.NvimConfig.set('grug_far_width', width)
  vim.cmd('vertical resize ' .. width)
end

M.open = function(path)
  local ok, grug_far = pcall(require, 'grug-far')

  if not ok then
    return
  end

  local prefills = {
    paths = path or Utils.Path.get_project_root(),
    filesFilter = [[!node_modules
!*.test.ts]],
  }

  if not grug_far.has_instance(instanceName) then
    grug_far.open({ instanceName = instanceName, prefills = prefills, transient = true })
  else
    grug_far.get_instance(instanceName):open()
    grug_far.get_instance(instanceName):update_input_values(prefills, false)
  end

  open_callback()
end

M.close = function()
  local ok, grug_far = pcall(require, 'grug-far')

  if not ok then
    return
  end

  grug_far.hide_instance(instanceName)
end

M.resume = function()
  local ok, grug_far = pcall(require, 'grug-far')

  if not ok then
    return
  end

  if grug_far.has_instance(instanceName) then
    grug_far.get_instance(instanceName):open()

    open_callback()
  else
    vim.notify('No GrugFar To Resume')
  end
end

return M
