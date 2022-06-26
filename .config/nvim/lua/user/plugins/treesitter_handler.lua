-- cSpell:ignore romgrk JoosepAlviste windwp
local queris_ok, queries = pcall(require, 'nvim-treesitter.query')
local parsers_ok, parsers = pcall(require, 'nvim-treesitter.parsers')

local M = {}

M.repo = 'nvim-treesitter/nvim-treesitter'
M.name = 'nvim-treesitter'
M.is_init = false

M.parsers = {
  bibtex = true,
  bash = true,
  c = true,
  c_sharp = true,
  cpp = true,
  css = true,
  dockerfile = true,
  dart = true,
  go = true,
  haskell = true,
  html = true,
  -- http = true,
  java = true,
  javascript = true,
  jsdoc = true,
  json = true,
  json5 = true,
  jsonc = true,
  kotlin = true,
  latex = true,
  lua = true,
  make = true,
  markdown = true,
  php = true,
  python = true,
  query = true,
  ruby = true,
  rust = true,
  scss = true,
  --sql = true,
  toml = true,
  tsx = true,
  typescript = true,
  vim = true,
  vue = true,
  yaml = true,
}

M.install_parsers = {}
for language, _ in pairs(M.parsers) do
  M.install_parsers[#M.install_parsers + 1] = language
end

function M.init(use, plugin_fn)
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use({
    M.repo,
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
      },
    },
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.get_default_disable(_, bufnr)
  return M.is_disable(bufnr)
end

function M.is_disable(bufnr)
  return bufnr and vim.api.nvim_buf_line_count(bufnr) > 5000
end

function M.setup()
  if not M.is_init then
    return
  end

  M.setup_more_ft()

  local ts_configs = require('nvim-treesitter.configs')
  ts_configs.setup({
    -- Parsers must be installed manually via :TSInstall
    ensure_installed = M.install_parsers, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
      enable = true, -- false will disable the whole extension
      additional_vim_regex_highlighting = false,
      disable = function(lang, bufnr) -- Disable in large C++ buffers
        local disables = {
          css = true,
          html = true,
        }
        -- return not (lang == 'cpp' and vim.api.nvim_buf_line_count(bufnr) > 50000)
        return disables[lang] or M.is_disable(bufnr)
      end,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<leader>ii',
        node_incremental = '<leader>in',
        scope_incremental = '<leader>ic',
        node_decremental = '<leader>im',
      },
      disable = M.get_default_disable,
    },
    indent = {
      enable = true,
      -- disable = { 'lua' }
      disable = M.get_default_disable,
    },
    textobjects = {
      select = {
        enable = true,
        disable = M.get_default_disable,
        lookahead = true, -- Automatically jump forward to text obj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
        },
      },
      move = {
        enable = true,
        disable = M.get_default_disable,
        set_jumps = true, -- whether to set jumps in the jump list
        goto_next_start = {
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[C'] = '@class.outer',
        },
      },
    },
    autopairs = {
      enable = true,
      disable = M.get_default_disable,
    },
    context_commentstring = {
      enable = true,
      disable = M.get_default_disable,
      enable_autocmd = false,
    },
    autotag = {
      enable = true,
      disable = M.get_default_disable,
    },
    rainbow = {
      enable = true,
      disable = M.get_default_disable,
    },
    playground = {
      enable = true,
      disable = M.get_default_disable,
    },
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
      disable = M.get_default_disable,
      -- [options]
    },
    refactor = {
      highlight_definitions = {
        enable = true,
        disable = M.get_default_disable,
        -- Set to false if you have an `updatetime` of ~100.
        clear_on_cursor_move = true,
      },
      smart_rename = {
        enable = true,
        disable = M.get_default_disable,
        keymaps = {
          smart_rename = '<leader>rr',
        },
      },
      navigation = {
        enable = true,
        disable = M.get_default_disable,
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

  require('user.plugins.which-key_handler').bind_which_keys(which_keys)
end

function M.update_highlight_pair()
  -- Apply my rainbow color to treesitter rainbow
  for i, color in ipairs(_G.rainbow_colors) do
    vim.cmd('highlight! default link rainbowcol' .. tostring(i) .. ' ' .. color)
  end
end

function M.setup_more_ft()
  local ft_to_parser = parsers.filetype_to_parsername
  local parser_config = parsers.get_parser_configs()

  ft_to_parser.xml = 'html'
  -- ft_to_parser.java = { 'java', 'jsdoc' }
  --
  -- parser_config.sql = {
  --   install_info = {
  --     url = 'https://github.com/m-novikov/tree-sitter-sql.git', -- local path or git repo
  --     files = { 'src/parser.c' },
  --     -- optional entries:
  --     branch = 'main', -- default branch in case of git repo if different from master
  --     generate_requires_npm = false, -- if stand-alone parser without npm dependencies
  --     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  --   },
  --   filetype = 'sql', -- if filetype does not match the parser name
  -- }
  -- parser_config.plantuml = {
  --   install_info = {
  --     url = 'https://github.com/lyndsysimon/tree-sitter-plantuml.git', -- local path or git repo
  --     files = { 'src/parser.c' },
  --     -- optional entries:
  --     branch = 'main', -- default branch in case of git repo if different from master
  --     generate_requires_npm = false, -- if stand-alone parser without npm dependencies
  --     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  --   },
  --   filetype = 'plantuml', -- if filetype does not match the parser name
  -- }
  -- M.parsers['sql'] = true
end

function M.assign_fold()
  if not M.is_init then
    return
  end

  local ts_ignore = {
    sql = true,
  }

  if parsers_ok then
    local language = parsers.ft_to_lang(vim.bo.filetype)
    if
      not ts_ignore[language]
      and M.parsers[language]
      and queries.get_query(language, 'folds') ~= nil
    then
      -- fillchars = 'fold: ',
      -- foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']],
      vim.opt_local.foldlevel = 99
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'

      return
    end
  end

  vim.opt_local.foldmethod = 'indent'
  vim.opt_local.foldlevel = 99
  -- vim.opt_local.foldlevelstart = 99
end

return M
