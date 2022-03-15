-- cSpell:ignore akinsho
local M = {}

M.repo = 'akinsho/toggleterm.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    config = plugin_fn('setup'),
    cmd = { 'ToggleTerm' },
    keys = { [[<C-\>]] },
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  ---@diagnostic disable-next-line: different-requires
  local toggleterm = require('toggleterm')
  toggleterm.setup({
    size = 15,
    -- size = vim.o.columns * 0.4,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'horizontal',
    -- direction = 'vertical',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      winblend = 0,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
    },
  })

  vim.cmd(
    [[autocmd! TermOpen term://* lua require('user.plugins.toggleterm').set_terminal_keymaps()]]
  )
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  -- Alternative map
  local binds = {
    {
      key = [[<M-\>]],
      cmd = [[<Cmd>exe "2ToggleTerm"<CR>]],
      opt = { silent = true },
    },
    {
      mode = 'i',
      key = [[<M-\>]],
      cmd = [[<Esc><Cmd>exe "2ToggleTerm"<CR>]],
      opt = { silent = true },
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
        [ [[<C-\>]] ] = 'Toggle Terminal',
        [ [[<M-\>]] ] = 'Toggle Alternative Terminal',
      },
    },
    {
      mapping = {
        [ [[<C-\>]] ] = 'which_key_ignore',
      },
      mode = { 'x', 'o' },
    },
  }

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

function M.set_terminal_keymaps()
  if not M.is_init then
    return
  end

  local binds = {
    -- {
    --   mode = 't',
    --   key = [[<Esc>]],
    --   cmd = [[<C-\><C-n>]],
    --   opt = { silent = true },
    -- },
    -- {
    --   mode = 't',
    --   key = [[jk]],
    --   cmd = [[<C-\><C-n>]],
    --   opt = { silent = true },
    -- },
    {
      mode = 't',
      key = [[<C-Space>]],
      cmd = [[<C-\><C-n>]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<C-h>]],
      cmd = [[<C-\><C-n><C-w>h]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<C-j>]],
      cmd = [[<C-\><C-n><C-w>j]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<C-k>]],
      cmd = [[<C-\><C-n><C-w>k]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<C-l>]],
      cmd = [[<C-\><C-n><C-w>l]],
      opt = { silent = true },
    },
    -- Alternative map
    {
      mode = 't',
      key = [[<M-\>]],
      cmd = [[<C-\><C-n><Cmd>exe "2ToggleTerm"<CR>]],
      opt = { silent = true },
    },
    -- Resize
    {
      mode = 't',
      key = [[<M-h>]],
      cmd = [[<C-\><C-n><Cmd>vertical resize -4<CR>i]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<M-j>]],
      cmd = [[<C-\><C-n><Cmd>resize -4<CR>i]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<M-k>]],
      cmd = [[<C-\><C-n><Cmd>resize +4<CR>i]],
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<M-l>]],
      cmd = [[<C-\><C-n><Cmd>vertical resize +4<CR>i]],
      opt = { silent = true },
    },
  }
  -- Fix spell check
  vim.opt_local.spell = false

  require('user.mappings').bind_buf_keys(0, binds)
end

return M
