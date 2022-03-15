local M = {}

M.repo = 'lewis6991/impatient.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    config = plugin_fn('setup'),
  })
  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local impatient = require('impatient')
  impatient.enable_profile()
end

return M
