-- cSpell:ignore Darazaki
local M = {}

M.repo = 'Darazaki/indent-o-matic'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  ---@diagnostic disable-next-line: different-requires
  local indent_o_matic = require('indent-o-matic')
  indent_o_matic.setup({
    -- The values indicated here are the defaults

    -- Number of lines without indentation before giving up (use -1 for infinite)
    max_lines = 2048,

    -- Space indentations that should be detected
    standard_widths = { 2, 4, 8 },
  })
end

return M
