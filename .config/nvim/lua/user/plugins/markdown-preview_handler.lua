-- cSpell:ignore iamcco
local M = {}

M.repo = 'iamcco/markdown-preview.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    run = 'cd app && npm install',
    ft = 'markdown',
    event = 'BufRead',
    -- config = plugin_fn('setup'),
  })

  vim.g.mkdp_browser = 'brave-popup'

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local template = require()
  template.setup()
end

return M
