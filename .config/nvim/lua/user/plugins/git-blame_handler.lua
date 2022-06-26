local mappings =  require('user.mappings')
local which_key = require('user.plugins.which-key_handler')

local M = {}

M.repo = 'f-person/git-blame.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    setup = plugin_fn('pre_setup'),
    cmd = { 'GitBlameEnable', 'GitBlameToggle' },
  })

  M.is_init = true and not _G.is_readonly_mode

  return { key = true, which_key = true }
end

function M.pre_setup()
  if not M.is_init then
    return
  end

  vim.g.gitblame_enabled = 0
  -- vim.g.gitblame_message_template = '<summary> • <date> • <author>'
  -- vim.g.gitblame_highlight_group = 'Comment'
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<leader>ht',
      cmd = '<Cmd>GitBlameToggle<CR>',
      opt = { silent = true },
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
        ['<leader>ht'] = 'Toggle Git Blame',
      },
    },
  }

  which_key.bind_which_keys(which_keys)
end

return M
