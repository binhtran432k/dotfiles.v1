-- cSpell:ignore kyazdani42
local M = {}

M.repo = 'kyazdani42/nvim-tree.lua'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    requires = require('user.plugins.web-devicons').repo,
    config = plugin_fn('setup'),
    cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local nvim_tree = require('nvim-tree')
  nvim_tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {
      'startify',
      'dashboard',
      'alpha',
    },
    auto_close = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    update_to_buf_dir = {
      enable = true,
      auto_open = true,
    },
    diagnostics = {
      enable = false,
      icons = {
        -- hint = '',
        -- info = '',
        -- warning = '',
        -- error = '',
        hint = '',
        info = '',
        warning = '',
        error = '',
      },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
    system_open = {
      cmd = nil,
      args = {},
    },
    filters = {
      dotfiles = false,
      custom = {},
    },
    git = {
      enable = true,
      ignore = true,
      timeout = 500,
    },
    view = {
      width = 30,
      height = 30,
      hide_root_folder = false,
      side = 'left',
      auto_resize = false,
      mappings = {
        custom_only = false,
        list = {
          { key = { 'l' }, action = 'cd' },
          { key = { 'h' }, action = 'parent_node' },
        },
      },
      number = true,
      relativenumber = true,
      signcolumn = 'yes',
    },
    trash = {
      cmd = 'trash',
      require_confirm = true,
    },
  })

  vim.cmd([[autocmd BufEnter * if bufname() =~ "NvimTree" | setlocal cursorline | endif]])
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

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

return M
