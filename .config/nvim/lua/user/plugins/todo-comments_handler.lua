-- cSpell:ignore folke
local mappings = require('user.mappings')
local telescope = require('user.plugins.telescope_handler')
local trouble = require('user.plugins.trouble_handler')
local which_key = require('user.plugins.which-key_handler')
local dependencies_handler = require('user.plugins.dependencies_handler')

local M = {}

M.repo = 'folke/todo-comments.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    requires = dependencies_handler.plenary,
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  ---@diagnostic disable-next-line: different-requires
  local todo_comments = require('todo-comments')
  todo_comments.setup()
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {}

  if telescope.is_init then
    binds[#binds + 1] = {
      key = '<leader>ft',
      cmd = '<cmd>TodoTelescope<cr>',
    }
  end

  if trouble.is_init then
    binds[#binds + 1] = {
      key = '<leader>xt',
      cmd = '<cmd>TodoTrouble<cr>',
    }
  end
  mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {}

  if telescope.is_init then
    which_keys[#which_keys + 1] = {
      mapping = {
        ['<leader>ft'] = 'Find todo',
      },
    }
  end

  if trouble.is_init then
    which_keys[#which_keys + 1] = {
      mapping = {
        ['<leader>xt'] = 'Trouble todo',
      },
    }
  end
  which_key.bind_which_keys(which_keys)
end

return M
