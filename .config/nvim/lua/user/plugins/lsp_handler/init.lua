-- cSpell:ignore williamboman
local M = {}

M.plugins = {
  'lsp-config',
  'lsp-installer',
  'lsp-signature',
  'null-ls',
  'jdtls',
  'lightbulb',
  'lua-dev',
}

function M.init(use, _)
  if vim.g.readonly_mode ~= 1 then
    require('user.plugins').init_plugins(
      use,
      'user.plugins.lsp_handler',
      M.plugins
    )
  end
end

return M
