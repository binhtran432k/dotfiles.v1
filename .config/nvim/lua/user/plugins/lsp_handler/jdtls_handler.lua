-- cSpell:ignore williamboman
local configs = require('user.configs')
local lsp_installer

local M = {}

M.repo = 'mfussenegger/nvim-jdtls'
M.lsp_name = 'jdtls'
M.plugin_fn = function(_) end
M.opts = {}
M.is_lsp_setup = false
M.is_init = false
M.setup_server = function() end

function M.init(use, plugin_fn)
  lsp_installer = lsp_installer or require('user.plugins.lsp_handler.lsp-installer_handler')

  use({
    M.repo,
    ft = { 'java' },
    after = lsp_installer.name,
    config = plugin_fn('setup'),
  })

  M.plugin_fn = plugin_fn
  M.is_init = true
end

function M.setup()
  M.setup_server = M._setup_server
end

function M._setup_server(server, on_attach, capabilities)
  if not M.is_init then
    return
  end

  local server_default_options = server:get_default_options()

  M.opts = {
    cmd = server_default_options.cmd,
    autostart = true,
    filetypes = { 'java' },
    root_dir = require('jdtls.setup').find_root({
      '.git',
      'mvnw',
      'gradlew',
    }),
    -- root_dir = server_default_options.root_dir,
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      allow_incremental_sync = true,
    },
    settings = {
      java = {
        codeGeneration = {
          generateComments = true,
        },
      },
    },
  }

  M.is_lsp_setup = true

  configs.register_filetype('java', 'jdtls', M.plugin_fn('lsp_setup'))

  configs.load_filetype_setups()
end

function M.lsp_setup()
  if not M.is_init then
    return
  end

  local jdtls = require('jdtls')
  jdtls.start_or_attach(M.opts)

  M._setup_commands()
end

function M._setup_commands()
  vim.cmd([[
  command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
  command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
  command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
  command! -buffer JdtJol lua require('jdtls').jol()
  command! -buffer JdtBytecode lua require('jdtls').javap()
  command! -buffer JdtJshell lua require('jdtls').jshell()
  ]])
end

return M
