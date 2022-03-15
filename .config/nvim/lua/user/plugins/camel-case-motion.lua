-- cSpell:ignore bkad
local which_key = require('user.plugins.which-key')

local M = {}

M.repo = 'bkad/CamelCaseMotion'
M.is_init = false

function M.init(use, plugin_fn)
  use({ M.repo, setup = plugin_fn('pre_setup'), event = 'BufEnter' })

  M.is_init = true

  return { which_key = true }
end

function M.pre_setup()
  if not M.is_init then
    return
  end

  vim.g.camelcasemotion_key = '<space>' -- For Camel motion
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<space>'] = {
          b = 'Previous camel word',
          e = 'Next end to camel word',
          w = 'Next camel word',
          ['ge'] = 'Previous end to camel word',
        },
      },
      mode = { 'n', 'x', 'o' },
    },
  }

  which_key.bind_which_keys(which_keys)
end

return M
