-- cSpell:ignore hrsh7th saadparwaiz1 onsails rafamadriz
-- local which_key = require('user.plugins.which-key')
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')
local configs = require('user.configs')

local M = {}

M.repo = 'hrsh7th/nvim-cmp'
M.name = 'nvim-cmp'
M.plugin_fn = function(_) end
M.is_init = false
M.use_tabnine = false
M.use_ripgrep = false
M.use_treesitter = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    requires = {
      { 'hrsh7th/cmp-buffer', after = M.name }, -- buffer completions
      { 'hrsh7th/cmp-path', after = M.name }, -- path completions
      {
        'hrsh7th/cmp-cmdline',
        after = M.name,
        -- event = 'CmdlineEnter',
      }, -- cmdline completions
      -- {
      --   'dmitmel/cmp-cmdline-history',
      --   after = M.name,
      --   -- event = 'CmdlineEnter',
      -- }, -- cmdline completions
      { 'hrsh7th/cmp-nvim-lsp', after = M.name }, -- work with cmp
      {
        'saadparwaiz1/cmp_luasnip',
        -- '~/.config/nvim/testplugin/cmp_luasnip',
        after = { M.name },
      }, -- snippet completions
      { 'f3fora/cmp-spell', after = M.name },
      {
        'onsails/lspkind-nvim',
        event = { 'InsertEnter', 'CmdlineEnter' },
      }, -- icons for cmp
      { 'ray-x/cmp-treesitter', after = M.name, fn = 'require("user.plugins.cmp_handler").toggle_treesitter' },
      { 'lukas-reineke/cmp-rg', after = M.name, fn = 'require("user.plugins.cmp_handler").toggle_ripgrep' },
      { 'hrsh7th/cmp-omni', after = M.name },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = M.name },
      { 'tzachar/cmp-tabnine', run = './install.sh', after = M.name, fn = 'require("user.plugins.cmp_handler").toggle_tabnine' },
      -- (( Snippets ))
      {
        'L3MON4D3/LuaSnip', -- Snippets plugin
        event = { 'InsertEnter', 'CmdlineEnter' },
        requires = {
          { 'rafamadriz/friendly-snippets' },
        },
      }, -- a bunch of snippets to use
    },
    after = {
      'lspkind-nvim',
      'LuaSnip',
    },
    -- commit = 'dbc72290295cfc63075dab9ea635260d2b72f2e5', -- Specifies a git commit to use
    config = plugin_fn('setup'),
  })

  M.plugin_fn = plugin_fn
  M.is_init = true

  return { filetype_setup = true, key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local function select_next_cmp(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end

  local function select_prev_cmp(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end

  local function toggle_cmp()
    if cmp.visible() then
      cmp.close()
    else
      cmp.complete()
    end
  end
  if not _G.is_readonly_mode then
    M.setup_tabnine()
    local lspkind = require('lspkind')

    -- be sure to load this first since it overwrites the snippets table.
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').lazy_load({
      paths = { './lua/user/snippets' },
    })

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
              treesitter = '[TS]',
              buffer = '[Buf]',
              nvim_lua = '[Lua]',
              rg = '[RG]',
              cmp_tabnine = '[T9]',
              path = '[Path]',
              spell = '[Spell]',
              cmdline = '[Cmd]',
              cmdline_history = '[His]',
              nvim_lsp_document_symbol = '[LSP_Doc]',
            })[entry.source.name]

            if entry.source.name == 'cmp_tabnine' then
              vim_item.kind = ''
              if
                entry.completion_item.data ~= nil
                and entry.completion_item.data.detail ~= nil
              then
                vim_item.kind = vim_item.kind
                  .. ' '
                  .. entry.completion_item.data.detail
              end
            end

            return vim_item
          end,
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = {
          i = toggle_cmp,
          c = toggle_cmp,
        },
        ['<C-l>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            return cmp.complete_common_string()
          end
          fallback()
        end),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-n>'] = select_next_cmp,
        ['<C-p>'] = select_prev_cmp,
        ['<Tab>'] = select_next_cmp,
        ['<S-Tab>'] = select_prev_cmp,
      }),
      sources = M.get_default_source(),
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
      sorting = M.get_default_sorting(),
    })
  end
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }, {
      { name = 'buffer' },
    }),
  })
  for _, cmd_type in ipairs({ '/', '?' }) do
    cmp.setup.cmdline(cmd_type, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'nvim_lsp_document_symbol' },
      }, {
        { name = 'buffer' },
      }),
    })
  end

  M.filetype_setup()
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<leader>tn',
      cmd = '<Cmd>lua require("user.plugins.cmp_handler").toggle_tabnine()<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>tr',
      cmd = '<Cmd>lua require("user.plugins.cmp_handler").toggle_ripgrep()<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>ts',
      cmd = '<Cmd>lua require("user.plugins.cmp_handler").toggle_treesitter()<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>tc',
      cmd = '<Cmd>lua require("user.plugins.cmp_handler").clear_toggle()<CR>',
      opt = { silent = true },
    },
  }

  mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<leader>t'] = {
          name = 'Toggle',
          n = 'Toggle Tabnine Cmp',
          r = 'Toggle Ripgrep Cmp',
          s = 'Toggle Treesitter Cmp',
          c = 'Clear Cmp Toggle',
        },
      },
    },
  }

  which_key.bind_which_keys(which_keys)
end

function M.setup_tabnine()
  local tabnine = require('cmp_tabnine.config')
  tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    -- run_on_every_keystroke = false,
    snippet_placeholder = '..',
    ignored_file_types = { -- default is not to ignore
      -- uncomment to ignore in lua:
      -- lua = true
      -- gitcommit = true,
    },
  })
end

function M.register_filetype_setup()
  if not M.is_init then
    return
  end

  -- configs.register_filetype('java', 'omni', M.plugin_fn('filetype_setup'))
  configs.register_filetype(
    'gitcommit',
    'default',
    M.plugin_fn('ft_gitcommit_setup')
  )
end

function M.filetype_setup()
  if not M.is_init then
    return
  end

  -- require('cmp').setup.buffer({
  --   sources = require('cmp').config.sources(
  --     { { name = 'omni' } },
  --     { { name = 'buffer' } }
  --   ),
  -- })
end

function M.ft_gitcommit_setup()
  if not M.is_init then
    return
  end

  local cmp = require('cmp')
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
    }),
  })
end

function M.get_default_source()
  local first_sources = {
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
  }
  local second_sources = {
    { name = 'spell' },
  }
  if M.use_treesitter then
    table.insert(first_sources, 5, { name = 'treesitter' })
  end
  if M.use_tabnine then
    table.insert(first_sources, 5, { name = 'cmp_tabnine' })
  end
  if M.use_ripgrep then
    table.insert(second_sources, 1, {
      name = 'rg',
      option = {
        additional_arguments = '--smart-case --hidden',
        -- debounce = 500,
      },
    })
  end
  return require('cmp').config.sources(first_sources, second_sources)
end

function M.get_default_sorting()
  local compare = require('cmp.config.compare')
  local comparators = {
    compare.offset,
    compare.exact,
    compare.score,
    compare.recently_used,
    compare.kind,
    compare.sort_text,
    compare.length,
    compare.order,
  }
  if M.use_tabnine then
    table.insert(comparators, 1, require('cmp_tabnine.compare'))
  end
  return {
    priority_weight = 2,
    comparators = comparators,
  }
end

function M.reload_source()
  local cmp = require('cmp')
  cmp.setup.buffer({
    sources = M.get_default_source(),
    sorting = M.get_default_sorting(),
  })

  local custom_sources_str = ""
  if (M.use_tabnine) then
    custom_sources_str = custom_sources_str .. "| tabnine "
  end
  if (M.use_ripgrep) then
    custom_sources_str = custom_sources_str .. "| ripgrep "
  end
  if (M.use_treesitter) then
    custom_sources_str = custom_sources_str .. "| treesitter "
  end
  custom_sources_str = custom_sources_str .. "|"
  print(custom_sources_str)
end

function M.toggle_tabnine()
  M.use_tabnine = not M.use_tabnine
  M.reload_source()
end

function M.toggle_ripgrep()
  M.use_ripgrep = not M.use_ripgrep
  M.reload_source()
end

function M.toggle_treesitter()
  M.use_treesitter = not M.use_treesitter
  M.reload_source()
end

function M.clear_toggle()
  M.use_tabnine = false
  M.use_ripgrep = false
  M.use_treesitter = false
  M.reload_source()
end

return M
