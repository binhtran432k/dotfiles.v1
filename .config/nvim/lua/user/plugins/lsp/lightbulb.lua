local M = {}

M.repo = 'kosayoda/nvim-lightbulb'
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

  vim.cmd(
    [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
  )
end

return M
