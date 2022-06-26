local lsp_config_handler = require(
  'user.plugins.lsp_handler.lsp-config_handler'
)

local M = {}

M.repo = 'folke/lua-dev.nvim'

function M.init(use)
  use({
    M.repo,
    after = lsp_config_handler.name,
  })
end

function M.get_setup()
  return require('lua-dev').setup({
    -- add any options here, or leave empty to use the default settings
    -- lspconfig = {
    --   cmd = {"lua-language-server"}
    -- },
  })
end

return M
