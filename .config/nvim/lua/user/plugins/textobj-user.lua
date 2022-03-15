-- cSpell:ignore sgur
local M = {}

M.repo = 'kana/vim-textobj-user'
M.name = 'vim-textobj-user'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'CursorHold',
    requires = {
      { 'kana/vim-textobj-entire', after = M.name },
      { 'sgur/vim-textobj-parameter', after = M.name },
      { 'kana/vim-textobj-indent', after = M.name },
    },
    setup = plugin_fn('pre_setup'),
  })

  M.is_init = true

  -- return { key = true, which_key = true }
end

function M.pre_setup()
  if not M.is_init then
    return
  end

  vim.g.vim_textobj_parameter_mapping = ','
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['[b'] = 'Prev BufferLine cycle',
        ['<leader>b'] = {
          name = 'BufferLine',
          e = 'Sort by extension',
        },
      },
      mode = 'n',
    },
  }

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

return M
