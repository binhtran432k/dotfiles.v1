local M = {}

function M.setup()
  require('user.plugins.vimtex').fix_conflict()
end

return M
