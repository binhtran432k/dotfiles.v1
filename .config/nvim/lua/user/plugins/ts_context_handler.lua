-- cSpell:ignore romgrk JoosepAlviste windwp
local treesitter = require('user.plugins.treesitter_handler')

local M = {}

-- M.repo = 'romgrk/nvim-treesitter-context'
M.repo = '/home/binhtran432k/.config/nvim/testplugin/nvim-treesitter-context'
M.is_init = false

function M.init(use, plugin_fn)
  -- do return end
  use({
    M.repo,
    after = treesitter.name,
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  -- Treesitter context
  local ts_context = require('treesitter-context')
  ts_context.setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    line_numbers = true,
    fake_relative_number = true,
    auto_scroll_off = true,
    scroll_off = nil,
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
      -- For all filetypes
      -- Note that setting an entry here replaces all other patterns for this entry.
      -- By setting the 'default' entry below, you can control which nodes you want to
      -- appear in the context window.
      default = {
        'class',
        'function',
        'method',
        'for', -- These won't appear in the context
        'do',
        'while',
        'if',
        'else',
        'switch',
        'case',
      },
      -- Example for a specific filetype.
      -- If a pattern is missing, *open a PR* so everyone can benefit.
      -- rust = {
      --   'impl_item',
      -- },
    },
    exact_patterns = {
      -- Example for a specific filetype with Lua patterns
      -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
      -- exactly match "impl_item" only)
      -- rust = true,
    },
  })

  -- Change highlight context
  vim.cmd([[highlight link TreesitterContext CursorLine]])
end

return M
