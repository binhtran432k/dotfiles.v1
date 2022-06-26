-- cSpell:ignore lukas-reineke
local mappings = require('user.mappings')
local M = {}

M.repo = 'lukas-reineke/indent-blankline.nvim'
M.is_init = false
M.extend_keys = {
  '0',
  '^',
  'za',
  'zo',
  'zA',
  'zO',
  'zR',
}

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true }
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
    char_list = { '¦', '┆', '┊' },
    buftype_exclude = { 'terminal', 'nofile' },
  })
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  -- Default mapping
  local binds = {}
  for _, key in pairs(M.extend_keys) do
    binds[#binds + 1] = M.get_extended_refresh_key(key)
  end

  mappings.bind_keys(binds)
end

function M.get_extended_refresh_key(key)
  return {
    key = key,
    cmd = string.format('%s<Cmd>IndentBlanklineRefresh<CR>', key),
    opt = { silent = true },
  }
end

return M
