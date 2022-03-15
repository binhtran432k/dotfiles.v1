-- cSpell:ignore romgrk JoosepAlviste windwp
local M = {}

M.repo = 'nvim-treesitter/nvim-treesitter'
M.name = 'nvim-treesitter'
M.is_init = false

M.languages = {
  'bibtex',
  'bash',
  'c',
  'c_sharp',
  'cpp',
  'css',
  'dockerfile',
  'dart',
  'go',
  'haskell',
  'html',
  'http',
  'java',
  'javascript',
  'jsdoc',
  'json',
  'json5',
  'jsonc',
  'kotlin',
  'latex',
  'lua',
  'make',
  'markdown',
  'php',
  'python',
  'query',
  'ruby',
  'rust',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vue',
  'yaml',
}

function M.init(use, plugin_fn)
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use({
    M.repo,
    -- event = 'BufRead',
    run = ':TSUpdate',
    requires = {
      -- Additional textobjects for treesitter
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = M.name },
      { 'nvim-treesitter/nvim-treesitter-refactor', after = M.name },
      { 'JoosepAlviste/nvim-ts-context-commentstring', after = M.name },
      { 'p00f/nvim-ts-rainbow', after = M.name }, -- for rainbow parenthesis
      { 'windwp/nvim-ts-autotag', after = M.name }, -- autotag with treesitter
      {
        'nvim-treesitter/playground',
        cmd = 'TSPlaygroundToggle',
        after = M.name,
      },
    },
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local ts_configs = require('nvim-treesitter.configs')
  ts_configs.setup({
    -- Parsers must be installed manually via :TSInstall
    ensure_installed = M.languages, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { 'css', 'html' },
      -- additional_vim_regex_highlighting = false
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<leader>ii',
        node_incremental = '<leader>in',
        scope_incremental = '<leader>ic',
        node_decremental = '<leader>im',
      },
    },
    indent = {
      enable = true,
      -- disable = { 'lua' }
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to text obj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['ia'] = '@iswap-list.inner',
          ['aa'] = '@iswap-list.outer',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jump list
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    autopairs = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    autotag = {
      enable = true,
    },
    rainbow = {
      enable = true,
    },
    playground = {
      enable = true,
    },
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
      -- [options]
    },
    refactor = {
      highlight_definitions = {
        enable = true,
        -- Set to false if you have an `updatetime` of ~100.
        clear_on_cursor_move = true,
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = '<leader>rr',
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = 'gnd',
          list_definitions = '<leader>nd',
          list_definitions_toc = '<leader>nD',
          goto_next_usage = ']nd',
          goto_previous_usage = '[nd',
        },
      },
    },
  })

  vim.cmd([[
  autocmd ColorScheme * lua require('user.plugins.treesitter').update_highlight_pair()
  ]])
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      mode = 'n',
      key = '<leader>',
      cmd = '',
      opt = {
        silent = false,
        noremap = false,
        expr = false,
        nowait = false,
      },
    },
  }

  require('user.mappings').bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['[b'] = 'Prev BufferLine cycle',
        ['<leader>b'] = {
          name = 'BufferLine',
          e = 'Sort by extension',
        },
      },
      mode = 'n',
    },
  }

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

function M.update_highlight_pair()
  -- Apply my rainbow color to treesitter rainbow
  for i, color in ipairs(_G.rainbow_colors) do
    vim.cmd('highlight default link rainbowcol' .. tostring(i) .. ' ' .. color)
  end
end

return M
