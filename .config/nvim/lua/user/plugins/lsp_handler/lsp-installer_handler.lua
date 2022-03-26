-- cSpell:ignore williamboman
local lsp_config
local jdtls

local M = {}

M.repo = 'williamboman/nvim-lsp-installer'
M.name = 'nvim-lsp-installer'
M.is_init = false
M.server_settings = {
  ['sumneko_lua'] = true,
}

function M.init(use, plugin_fn)
  jdtls = jdtls or require('user.plugins.lsp_handler.jdtls_handler')
  lsp_config = lsp_config or require('user.plugins.lsp_handler.lsp-config_handler')

  use({
    M.repo,
    config = plugin_fn('setup'),
    after = lsp_config.name,
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local lsp_installer = require('nvim-lsp-installer')

  -- Register a handler that will be called for all installed servers.
  -- Alternatively, you may also register handlers on specific server instances instead (see example below).
  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = require('user.plugins.lsp_handler.lsp-config_handler').get_on_attach(),
      capabilities = require('user.plugins.lsp_handler.lsp-config_handler').get_capabilities(),
    }

    if server.name == jdtls.lsp_name then
      return jdtls.setup_server(server, opts.on_attach, opts.capabilities)
    end

    if M.server_settings[server.name] then
      local sv_opts = require('user.plugins.lsp_handler.settings.' .. server.name)
      opts = vim.tbl_deep_extend('force', sv_opts, opts)
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end)
end

return M
