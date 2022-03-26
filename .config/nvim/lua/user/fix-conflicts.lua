local M = {}

function M.setup()
  require('user.plugins.vimtex_handler').fix_conflict()
end

return M
