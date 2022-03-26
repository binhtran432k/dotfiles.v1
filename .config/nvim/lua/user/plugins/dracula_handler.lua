-- cSpell:ignore Mofiqul itchyny
local M = {}

M.repo = 'Mofiqul/dracula.nvim'
M.name = 'dracula.nvim'
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

  -- show the '~' characters after the end of buffers
  -- vim.g.dracula_show_end_of_buffer = false
  -- use transparent background
  -- vim.g.dracula_transparent_bg = false
  -- set custom lualine background color
  -- vim.g.dracula_lualine_bg_color = '#44475a'
  -- set italic comment
  vim.g.dracula_italic_comment = true

  vim.cmd([[
  syntax on
  colorscheme dracula
  ]])

  vim.cmd([[
  autocmd ColorScheme * lua require('user.plugins.treesitter_handler').update_highlight_pair()
  ]])

  require('user.plugins.treesitter_handler').update_highlight_pair()
end

return M
