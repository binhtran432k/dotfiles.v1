-- cSpell:ignore lukas-reineke
local M = {}

M.repo = 'lukas-reineke/indent-blankline.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local indent_blankline = require('indent_blankline')
  indent_blankline.setup({
    char = '┊',
    space_char_blankline = ' ',
    char_highlight_list = _G.rainbow_colors,
    show_trailing_blankline_indent = false,
    filetype_exclude = _G.special_file_types,
    buftype_exclude = { 'terminal', 'nofile' },
  })
end

return M
