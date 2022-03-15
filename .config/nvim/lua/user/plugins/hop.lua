-- cSpell: ignore phaazon
local M = {}

M.repo = 'phaazon/hop.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    -- branch = 'v1', -- optional but strongly recommended
    cmd = { 'HopWord', 'HopChar2' },
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
  local hop = require('hop')
  hop.setup()
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = 's',
      cmd = '<Cmd>HopChar2<CR>',
      opt = { silent = true },
    },
    {
      key = 'S',
      cmd = '<Cmd>HopWord<CR>',
      opt = { silent = true },
    },
    {
      mode = { 'x', 'o' },
      key = 'x',
      cmd = '<Cmd>HopChar2<CR>',
      opt = { silent = true },
    },
    {
      mode = { 'x', 'o' },
      key = 'X',
      cmd = '<Cmd>HopWord<CR>',
      opt = { silent = true },
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
        ['s'] = 'Move before 2 char by Hop',
        ['S'] = 'Move before word by Hop',
      },
    },
    {
      mapping = {
        ['x'] = 'Move before 2 char by Hop',
        ['X'] = 'Move before word by Hop',
      },
      mode = { 'o', 'x' },
    },
  }

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

return M
