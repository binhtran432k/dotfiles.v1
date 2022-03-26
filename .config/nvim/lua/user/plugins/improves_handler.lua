-- cSpell:ignore antoinemadec rhysd
local M = {}

function M.init(use, _)
  use({
    { 'antoinemadec/FixCursorHold.nvim' },
    { 'rhysd/conflict-marker.vim' },
  })
end

return M
