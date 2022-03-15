local M = {}

function M.setup()
  require('user.globals').setup()
  require('user.plugins').setup()
  require('user.mappings').setup()
  require('user.configs').setup()
  -- require('user.scripts')
  require('user.ibus').setup()
  -- require('user.vietnamese-keymap').setup()
  require('user.fix-conflicts').setup()
end

return M
