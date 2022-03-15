-- cSpell:ignore williamboman
local M = {}

M.plugins = {
  'lsp-config',
  'lsp-installer',
  'lsp-signature',
  'null-ls',
  'jdtls',
  'lightbulb',
}

function M.init(use, _)
  require('user.plugins').init_plugins(use, 'user.plugins.lsp', M.plugins)
end

return M
