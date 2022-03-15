-- cSpell:ignore
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key')

local M = {}

M.repo = ''
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local template = require()
  template.setup()
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

  mappings.bind_keys(binds)
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

  which_key.bind_which_keys(which_keys)
end

return M
