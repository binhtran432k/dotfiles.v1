-- cSpell:ignore xiyaowong akinsho
local dracula_handler = require('user.plugins.dracula_handler')
local M = {}

M.repo = 'xiyaowong/nvim-transparent'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    after = dracula_handler.name,
    config = plugin_fn('setup')
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  ---@diagnostic disable-next-line: different-requires
  local transparent = require('transparent')
  transparent.setup({
    enable = true, -- boolean: enable transparent
    extra_groups = { -- table/string: additional groups that should be clear
      -- In particular, when you set it to 'all', that means all available groups
      -- Floating window
      'NormalFloat',
      -- NvimTree
      'NvimTreeNormal',
      'NvimTreeVertSplit',
      -- Telescope
      'TelescopeNormal',
      -- example of akinsho/nvim-bufferline.lua
      'BufferLineTabClose',
      'BufferlineBufferSelected',
      'BufferLineFill',
      'BufferLineBackground',
      'BufferLineSeparator',
      'BufferLineIndicatorSelected',
      'BufferLineCloseButton',
      'BufferLineCloseButtonSelected',
    },
    exclude = {}, -- table: groups you don't want to clear
  })
end

return M
