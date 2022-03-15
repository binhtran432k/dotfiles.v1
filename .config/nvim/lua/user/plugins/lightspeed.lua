-- cSpell:ignore ggandor
local M = {}

M.repo = 'ggandor/lightspeed.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    requires = require('user.plugins.repeat').repo,
    config = plugin_fn('setup')
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  ---@diagnostic disable-next-line: different-requires
  local lightspeed = require('lightspeed')
  lightspeed.setup({
    ignore_case = true,
  })
  -- Fix leader mappings
  vim.cmd('silent! unmap ;')
  vim.cmd('silent! unmap ,')
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end
end

return M
