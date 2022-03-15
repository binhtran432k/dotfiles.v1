-- cSpell:ignore williamboman
local lsp_config = require('user.plugins.lsp.lsp-config')

local M = {}

M.repo = 'jose-elias-alvarez/null-ls.nvim'
M.is_init = false
M.override_lsp_formatings = {
  'tsserver',
  'html',
  -- 'jdtls',
}
M.extra_ft_formattings = {
  -- 'toml',
  'json',
  'jsonc',
  'yaml',
  'markdown',
}

function M.init(use, plugin_fn)
  use({
    M.repo,
    after = lsp_config.name,
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local null_ls = require('null-ls')

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  -- local diagnostics = null_ls.builtins.diagnostics

  -- https://github.com/prettier-solidity/prettier-plugin-solidity
  -- npm install --save-dev prettier prettier-plugin-solidity
  null_ls.setup({
    debug = false,
    sources = {
      formatting.prettier.with({
        extra_filetypes = { 'toml', 'solidity' },
        extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' },
      }),
      formatting.black.with({ extra_args = { '--fast' } }),
      formatting.stylua,
      -- diagnostics.cspell.with({
      --   extra_args = { '--locale', '"en, vi"', '--unique' },
      -- }),
    },
    should_attach = function(bufnr)
      local file_type = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      for _, disable_ft in ipairs(_G.special_file_types) do
        if file_type == disable_ft then
          return false
        end
      end
      return true
    end,
    -- fallback_severity = vim.diagnostic.severity.HINT,
  })

  lsp_config.setup_extra_formatings(M.extra_ft_formattings)
end

return M
