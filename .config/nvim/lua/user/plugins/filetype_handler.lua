-- cSpell:ignore nathom
local M = {}

M.repo = 'nathom/filetype.nvim'
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

  local filetype = require('filetype')
  filetype.setup({
    overrides = {
      extensions = {
        json = 'jsonc',
        scm = 'query',
      },
      literal = {
        config = 'config',
      },
    },
  })
end

return M
