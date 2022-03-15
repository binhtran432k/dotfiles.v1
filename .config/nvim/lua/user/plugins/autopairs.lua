-- cSpell:ignore windwp qwertyuiopzxcvbnmasdfghjkl
local cmp = require('user.plugins.cmp')

local M = {}

M.repo = 'windwp/nvim-autopairs' -- Autopairs, integrates with both cmp and treesitter
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'InsertCharPre',
    ---@diagnostic disable-next-line: different-requires
    after = cmp.name,
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local autopairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')
  local cond = require('nvim-autopairs.conds')

  autopairs.setup({
    check_ts = true,
    ts_config = {
      lua = { 'string', 'source' },
      javascript = { 'string', 'template_string' },
      -- java = false,
    },
    disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      offset = 0, -- Offset from pattern match
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey = 'Comment',
    },
  })

  -- add space to end of bracket
  autopairs.add_rules({
    Rule(' ', ' ')
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ '()', '{}', '[]' }, pair)
      end)
      :with_move(cond.none())
      :with_cr(cond.none())
      :with_del(function(opts)
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local context = opts.line:sub(col - 1, col + 2)
        return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
      end),
    Rule('', ' )')
      :with_pair(cond.none())
      :with_move(function(opts)
        return opts.char == ')'
      end)
      :with_cr(cond.none())
      :with_del(cond.none())
      :use_key(')'),
    Rule('', ' }')
      :with_pair(cond.none())
      :with_move(function(opts)
        return opts.char == '}'
      end)
      :with_cr(cond.none())
      :with_del(cond.none())
      :use_key('}'),
    Rule('', ' ]')
      :with_pair(cond.none())
      :with_move(function(opts)
        return opts.char == ']'
      end)
      :with_cr(cond.none())
      :with_del(cond.none())
      :use_key(']'),
  })

  local cmp_plugin = require('cmp')
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp_plugin.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done({ map_char = { tex = '{' } })
  )
end

return M
