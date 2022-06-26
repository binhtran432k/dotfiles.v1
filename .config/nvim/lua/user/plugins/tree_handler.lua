-- cSpell:ignore kyazdani42
local dependencies_handler = require('user.plugins.dependencies_handler')
local M = {}

M.repo = 'kyazdani42/nvim-tree.lua'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    requires = dependencies_handler.name,
    config = plugin_fn('setup'),
    cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
  })

  M.is_init = true
  M.setup_autocmd()

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local nvim_tree = require('nvim-tree')
  nvim_tree.setup({
    ignore_ft_on_setup = {
      'startify',
      'dashboard',
      'alpha',
    },
    diagnostics = {
      enable = false,
      icons = {
        hint = ' ',
        info = ' ',
        warning = ' ',
        error = ' ',
      },
    },
    filters = {
      dotfiles = true,
    },
    renderer = {
      group_empty = true,
    },
    view = {
      side = 'left',
      adaptive_size = true,
      mappings = {
        list = {
          { key = 'l', action = 'cd' },
          { key = '<space>', action = 'preview' },
          { key = 'u', action = 'dir_up' },
        },
      },
      -- number = true,
      -- relativenumber = true,
      -- signcolumn = 'yes',
    },
  })

  vim.cmd(
    [[autocmd BufEnter * if bufname() =~ "NvimTree" | setlocal cursorline | endif]]
  )
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<C-n>',
      cmd = '<Cmd>NvimTreeToggle<CR>',
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
        ['<C-n>'] = 'Toggle nvim tree',
      },
    },
  }

  require('user.plugins.which-key_handler').bind_which_keys(which_keys)
end

function M.setup_autocmd()
  if not M.is_init then
    return
  end

  vim.cmd([[
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
      \ execute 'cd '.argv()[0] | execute 'NvimTreeOpen' | endif
  ]])
end

return M
