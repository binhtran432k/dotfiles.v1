-- cSpell:ignore dstein64
local M = {}

M.repo = 'dstein64/vim-startuptime'
M.is_init = false

function M.init(use, _)
  use({
    M.repo,
    cmd = 'StartupTime',
  })

  M.is_init = true
end

return M
