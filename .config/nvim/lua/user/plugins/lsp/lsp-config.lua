local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key')
local trouble = require('user.plugins.trouble')
local telescope = require('user.plugins.telescope')
local null_ls

local M = {}

M.repo = 'neovim/nvim-lspconfig'
M.name = 'nvim-lspconfig'
M.is_init = false

function M.init(use, plugin_fn)
  null_ls = null_ls or require('user.plugins.lsp.null-ls')
  use({
    M.repo,
    config = plugin_fn('setup'),
    event = 'BufRead',
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
    })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
      border = 'rounded',
    }
  )
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = 'gl',
      cmd = '<Cmd>lua vim.diagnostic.open_float()<CR>',
      opt = { silent = true },
    },
    {
      key = '[d',
      cmd = [[<Cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>]],
      opt = { silent = true },
    },
    {
      key = ']d',
      cmd = [[<Cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>]],
      opt = { silent = true },
    },
  }

  if trouble.is_init then
    binds[#binds + 1] = {
      key = '<leader>q',
      cmd = '<Cmd>Trouble loclist<CR>',
      opt = { silent = true },
    }
  else
    binds[#binds + 1] = {
      key = '<leader>q',
      cmd = [[<Cmd>lua vim.diagnostic.setloclist()<CR>]],
      opt = { silent = true },
    }
  end

  mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['gl'] = 'Preview diagnostic',
        ['[d'] = 'Previous diagnostic',
        [']d'] = 'Next diagnostic',
        ['<leader>q'] = 'Show diagnostic location list',
      },
    },
  }

  which_key.bind_which_keys(which_keys)
end

function M.setup_extra_formatings(extras)
  local bufnr = 0
  local file_type = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  for _, extra_ft in ipairs(extras) do
    if file_type == extra_ft then
      M.setup_formarting(bufnr)
    end
  end
end

function M.setup_disable_lsp_formatings(client, disables)
  for _, disable_client in ipairs(disables) do
    if client.name == disable_client then
      client.resolved_capabilities.document_formatting = false
    end
  end
end

function M.setup_formarting(bufnr)
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<leader>p',
      cmd = [[<Cmd>lua vim.lsp.buf.formatting()<CR>]],
      opt = { silent = true },
    },
  }
  mappings.bind_buf_keys(bufnr, binds)

  local which_keys = {
    {
      mapping = {
        ['<leader>p'] = 'Format code',
      },
    },
  }
  which_key.bind_buf_which_keys(bufnr, which_keys)

  vim.cmd([[command! Format execute 'lua vim.lsp.buf.formatting()']])

  vim.cmd(
    [[command! LspToggleAutoFormat execute 'lua require("user.plugins.lsp.lsp-config").toggle_format_on_save()']]
  )
end

function M.setup_lsp_highlight_document(client, bufnr)
  local ftToIgnore = {
    'html',
  }

  local file_type = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  for _, disable_ft in ipairs(ftToIgnore) do
    if file_type == disable_ft then
      return
    end
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false
    )
  end
end

function M.setup_lsp_keymaps(bufnr)
  local binds = {
    {
      key = 'gD',
      cmd = [[<Cmd>lua vim.lsp.buf.declaration()<CR>]],
      opt = { silent = true },
    },
    {
      key = 'gd',
      cmd = [[<Cmd>lua vim.lsp.buf.definition()<CR>]],
      opt = { silent = true },
    },
    {
      key = 'gI',
      cmd = [[<Cmd>lua vim.lsp.buf.implementation()<CR>]],
      opt = { silent = true },
    },
    {
      key = 'gnt',
      cmd = [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]],
      opt = { silent = true },
    },
    {
      key = 'K',
      cmd = [[<Cmd>lua vim.lsp.buf.hover()<CR>]],
      opt = { silent = true },
    },
    {
      key = 'gK',
      cmd = [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]],
      opt = { silent = true },
    },
    {
      key = '<leader>wa',
      cmd = [[<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]],
      opt = { silent = true },
    },
    {
      key = '<leader>wr',
      cmd = [[<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]],
      opt = { silent = true },
    },
    {
      key = '<leader>wl',
      cmd = [[<Cmd>lua vim.lsp.buf.list_workspace_folders()<CR>]],
      opt = { silent = true },
    },
    {
      key = '<leader>rn',
      cmd = [[<Cmd>lua vim.lsp.buf.rename()<CR>]],
      opt = { silent = true },
    },
    {
      key = '<leader>ca',
      cmd = [[<Cmd>lua vim.lsp.buf.code_action()<CR>]],
      opt = { silent = true },
    },
  }

  if telescope.is_init then
    binds[#binds + 1] = {
      key = '<leader>so',
      cmd = [[<Cmd>Telescope lsp_document_symbols<CR>]],
      opt = { silent = true },
    }
  end

  if trouble.is_init then
    binds[#binds + 1] = {
      key = 'gr',
      cmd = [[<Cmd>Trouble lsp_references<CR>]],
      opt = { silent = true },
    }
  else
    binds[#binds + 1] = {
      key = 'gr',
      cmd = [[<Cmd>lua vim.lsp.buf.references()<CR>]],
      opt = { silent = true },
    }
  end

  mappings.bind_buf_keys(bufnr, binds)
end

function M.get_on_attach()
  return function(client, bufnr)
    if null_ls.is_init then
      M.setup_disable_lsp_formatings(client, null_ls.override_lsp_formatings)
    end

    M.setup_formarting(bufnr)
    M.setup_lsp_keymaps(bufnr)
    -- M.setup_lsp_highlight_document(client, bufnr)
  end
end

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local cmp_nvim_lsp = require('cmp_nvim_lsp')
  return cmp_nvim_lsp.update_capabilities(capabilities)
end

function M.enable_format_on_save()
  vim.cmd([[
    augroup format_on_save
      autocmd!
      autocmd BufWritePre * lua vim.lsp.buf.formatting()
    augroup end
    ]])
  vim.notify('Enabled format on save')
end

function M.disable_format_on_save()
  M.remove_augroup('format_on_save')
  vim.notify('Disabled format on save')
end

function M.toggle_format_on_save()
  if vim.fn.exists('#format_on_save#BufWritePre') == 0 then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

function M.remove_augroup(name)
  if vim.fn.exists('#' .. name) == 1 then
    vim.cmd('au! ' .. name)
  end
end

function M.get_lualine(fmt)
  return {
    -- Lsp server name .
    function()
      local msg = 'No Active Lsp'
      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end,
    icon = '',
    fmt = fmt,
  }
end

return M
