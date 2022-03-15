-- cSpell:ignore hrsh7th saadparwaiz1 onsails rafamadriz
local which_key = require('user.plugins.which-key')

local M = {}

M.repo = 'hrsh7th/nvim-cmp'
M.name = 'nvim-cmp'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    requires = {
      { 'hrsh7th/cmp-buffer', after = M.name }, -- buffer completions
      { 'hrsh7th/cmp-path', after = M.name }, -- path completions
      {
        'hrsh7th/cmp-cmdline',
        after = M.name,
        event = 'CmdlineEnter',
      }, -- cmdline completions
      { 'hrsh7th/cmp-nvim-lsp', after = M.name }, -- work with cmp
      {
        'saadparwaiz1/cmp_luasnip',
        after = { M.name },
      }, -- snippet completions
      { 'f3fora/cmp-spell', after = M.name },
      {
        'onsails/lspkind-nvim',
        event = { 'InsertEnter', 'CmdlineEnter' },
      }, -- icons for cmp
      -- (( Snippets ))
      {
        'L3MON4D3/LuaSnip', -- Snippets plugin
        event = { 'InsertEnter', 'CmdlineEnter' },
        requires = {
          'rafamadriz/friendly-snippets',
          after = 'LuaSnip',
        },
      }, -- a bunch of snippets to use
    },
    after = {
      'lspkind-nvim',
      'LuaSnip',
    },
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local lspkind = require('lspkind')

  require('luasnip.loaders.from_vscode').lazy_load()

  -- local function check_backspace ()
  --   local col = vim.fn.col('.') - 1
  --   return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
  -- end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    formatting = {
      format = lspkind.cmp_format({
        -- mode = 'symbol', -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          vim_item.menu = ({
            luasnip = '[Snip]',
            nvim_lsp = '[LSP]',
            buffer = '[Buf]',
            nvim_lua = '[Lua]',
            cmp_tabnine = '[Tab9]',
            path = '[Path]',
            spell = '[Spell]',
            cmdline = '[Cmd]',
          })[entry.source.name]
          return vim_item
        end,
      }),
    },
    mapping = {
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end, { 'i', 'c' }),
      ['<C-e>'] = {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = 'path' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'spell' },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    documentation = {
      border = 'rounded',
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
  })
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }, {
      { name = 'buffer' },
    }),
  })
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' },
    },
  })
  cmp.setup.cmdline('?', {
    sources = {
      { name = 'buffer' },
    },
  })
end

function M.get_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {}

  which_key.bind_which_keys(which_keys)
end

return M
