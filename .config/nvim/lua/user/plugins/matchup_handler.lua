-- cSpell:ignore andymass
local M = {}

M.repo = 'andymass/vim-matchup'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    -- after = require('user.plugins.treesitter').name,
    setup = plugin_fn('pre_setup'),
  })

  M.is_init = true
end

function M.pre_setup()
  if not M.is_init then
    return
  end

  vim.g.matchup_enabled = 1
  vim.g.matchup_matchparen_offscreen = { method = nil }
  vim.g.matchup_matchpref = { html = { nolists = 1 } }
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end
end

return M
