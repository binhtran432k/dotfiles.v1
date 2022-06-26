-- cSpell:ignore williamboman
local lsp_config
local jdtls

local M = {}

M.repo = 'williamboman/nvim-lsp-installer'
M.name = 'nvim-lsp-installer'
M.is_init = false
M.ensure_install = {
  'clangd',
  'emmet_ls',
  'html',
  'jdtls',
  'jsonls',
  'kotlin_language_server',
  'prosemd_lsp',
  'pyright',
  'stylelint_lsp',
  'cssls',
  'tsserver',
  'sumneko_lua',
}
M.servers = vim.list_extend(M.ensure_install, {})
M.server_settings = {
  sumneko_lua = true,
}

function M.init(use, plugin_fn)
  jdtls = jdtls or require('user.plugins.lsp_handler.jdtls_handler')
  lsp_config = lsp_config
      or require('user.plugins.lsp_handler.lsp-config_handler')

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

  local lspinstaller = require('nvim-lsp-installer')
  lspinstaller.setup({
    ensure_installed = M.ensure_install, -- ensure these servers are always installed
    automatic_installation = false, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
      icons = {
        server_installed = '✓',
        server_pending = '➜',
        server_uninstalled = '✗',
      },
    },
  })

  local lspconfig = require('lspconfig')
  for _, server_name in ipairs(M.servers) do
    local opts = {
      on_attach = require('user.plugins.lsp_handler.lsp-config_handler').get_on_attach(),
      capabilities = require('user.plugins.lsp_handler.lsp-config_handler').get_capabilities(),
    }

    if server_name == jdtls.lsp_name then
      jdtls.setup_home()
      local server_ok, server = lspinstaller.get_server(server_name)
      if server_ok then
        jdtls.setup_server(server, opts.on_attach, opts.capabilities)
      end
    else
      if M.server_settings[server_name] then
        local sv_opts = require(
          'user.plugins.lsp_handler.settings.' .. server_name
        )
        opts = vim.tbl_deep_extend('force', sv_opts, opts)
      end

      lspconfig[server_name].setup(opts)
    end
  end
end

return M
