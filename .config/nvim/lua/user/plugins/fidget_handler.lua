local M = {}

M.repo = 'j-hui/fidget.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local fidget = require('fidget')
  fidget.setup({
    window = {
      blend = 0,
    },
  })
end

function M.update_highlight()
  vim.cmd([[
  highlight! default link FidgetTitle Title
  highlight! default link FidgetTask Comment
  ]])
end

return M
