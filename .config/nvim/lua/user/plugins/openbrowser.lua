-- cSpell:ignore tyru itchyny
local M = {}

M.repo = 'tyru/open-browser.vim'
M.name = 'open-browser.vim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    config = plugin_fn('setup'),
    requires = { 'itchyny/vim-highlighturl', after = M.name },
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  vim.g.netrw_nogx = 1 -- disable netrw's gx mapping

  vim.cmd([[
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  ]])

  vim.g.openbrowser_default_search = 'duckduckgo'
end

return M
