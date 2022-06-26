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
  lsp_installer = lsp_installer
      or require('user.plugins.lsp_handler.lsp-installer_handler')

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

function M.setup_home()
  vim.env.JAVA_HOME = '/usr/lib/jvm/java-17-openjdk'
end

function M._setup_server(server, on_attach, capabilities)
  if not M.is_init then
    return
  end

  local server_default_options = server:get_default_options()

  M.opts = vim.tbl_deep_extend('force', server_default_options, {
    name = 'jdtls',
    filetypes = { 'java' },
    root_dir = server_default_options.root_dir,
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
      -- require('jdtls.dap').setup_dap_main_class_configs({ verbose = true })
      on_attach(client, bufnr)
    end,
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
    init_options = {
      bundles = {
        vim.fn.glob(
          '/home/binhtran432k/.local/share/nvim/lsp_servers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
        ),
      },
    },
  })

  M.is_lsp_setup = true

  configs.register_filetype('java', 'jdtls', M.plugin_fn('lsp_setup'))

  configs.load_filetype_setups()
end

function M.lsp_setup()
  if not M.is_init then
    return
  end

  require('jdtls.setup').add_commands()

  local jdtls = require('jdtls')
  jdtls.start_or_attach(M.opts)

  vim.cmd([[
  nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
  nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
  ]])
end

function M._setup_commands()
  vim.cmd([[
  command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
  command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
  command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
  command! -buffer JdtJol lua require('jdtls').jol()
  command! -buffer JdtBytecode lua require('jdtls').javap()
  command! -buffer JdtJshell lua require('jdtls').jshell()
  command! -buffer JdtDap lua require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  ]])
end

return M
