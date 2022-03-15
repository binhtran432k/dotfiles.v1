-- cSpell:ignore chaoren
local which_key = require('user.plugins.which-key')

local M = {}

M.repo = 'chaoren/vim-wordmotion'
M.is_init = false

function M.init(use, plugin_fn)
  use({ M.repo, event = 'CursorHold', setup = plugin_fn('pre_setup') })

  M.is_init = true

  return { which_key = true }
end

function M.pre_setup()
  vim.g.wordmotion_prefix = '<space>'
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<space>'] = {
          name = 'Word motion',
          b = 'Previous camel word',
          w = 'Next camel word',
          ge = 'Previous end of camel word',
          e = 'Next end of camel word',
        },
      },
      mode = 'n',
    },
  }

  which_key.bind_which_keys(which_keys)
end

return M
