-- cSpell:ignore machakann
local M = {}

M.repo = 'machakann/vim-sandwich'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'CursorHold',
    config = plugin_fn('setup'),
  })

  M.is_init = true

  -- return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  -- Use vim surround-like keybindings
  vim.api.nvim_command('runtime macros/sandwich/keymap/surround.vim')
  -- '{' will insert space, '}' will not
  vim.g['sandwich#recipes'] = vim.list_extend(vim.g['sandwich#recipes'], {
    {
      buns = { '{ ', ' }' },
      nesting = 1,
      match_syntax = 1,
      kind = { 'add', 'replace' },
      action = { 'add' },
      input = { '{' },
    },
    {
      buns = { '[ ', ' ]' },
      nesting = 1,
      match_syntax = 1,
      kind = { 'add', 'replace' },
      action = { 'add' },
      input = { '[' },
    },
    {
      buns = { '( ', ' )' },
      nesting = 1,
      match_syntax = 1,
      kind = { 'add', 'replace' },
      action = { 'add' },
      input = { '(' },
    },
    {
      buns = { '{\\s*', '\\s*}' },
      nesting = 1,
      regex = 1,
      match_syntax = 1,
      kind = { 'delete', 'replace', 'textobj' },
      action = { 'delete' },
      input = { '{' },
    },
    {
      buns = { '\\[\\s*', '\\s*\\]' },
      nesting = 1,
      regex = 1,
      match_syntax = 1,
      kind = { 'delete', 'replace', 'textobj' },
      action = { 'delete' },
      input = { '[' },
    },
    {
      buns = { '(\\s*', '\\s*)' },
      nesting = 1,
      regex = 1,
      match_syntax = 1,
      kind = { 'delete', 'replace', 'textobj' },
      action = { 'delete' },
      input = { '(' },
    },
  })
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      mode = 'n',
      key = '<leader>',
      cmd = '',
      opt = {
        silent = false,
        noremap = false,
        expr = false,
        nowait = false,
      },
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
