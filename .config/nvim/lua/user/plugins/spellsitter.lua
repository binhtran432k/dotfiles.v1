-- cSpell:ignore
local M = {}

M.repo = 'lewis6991/spellsitter.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    config = plugin_fn('setup'),
  })

  M.is_init = true

  -- return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local spellsitter = require('spellsitter')
  spellsitter.setup({
    enable = true,
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

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

return M
