-- cSpell:ignore akinsho
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')

local M = {}

M.repo = 'akinsho/toggleterm.nvim'
M.is_init = false

M.lazygit_term = {}
M.ranger_term = {}
M.lazygit_toggle = function() end
M.ranger_toggle = function() end
M.plugin_fn = function(_) end

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = { 'BufRead' },
    config = plugin_fn('setup'),
    -- cmd = { 'ToggleTerm' },
    -- keys = { [[<C-\>]] },
  })

  M.plugin_fn = plugin_fn
  M.is_init = true and not _G.is_readonly_mode

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local toggleterm = require('toggleterm')
  toggleterm.setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    -- size = vim.o.columns * 0.4,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    -- shading_factor = 2,
    start_in_insert = false,
    insert_mappings = true,
    persist_size = false,
    direction = 'horizontal', -- float, tab, vertical, horizontal
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'rounded',
      winblend = 0,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
    },
  })

  vim.cmd([[
    autocmd! TermOpen term://* lua require('user.plugins.toggleterm_handler').set_terminal_keymaps()
    autocmd! FileType toggleterm startinsert
    " autocmd! WinEnter term://* startinsert
    ]])

  M.setup_custom()
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {}
  for i = 1, 3, 1 do
    binds[#binds + 1] = {
      key = string.format([[<M-%d>]], i),
      cmd = string.format([[<Cmd>exe "%dToggleTerm"<CR>]], i),
      opt = { silent = true },
    }
    binds[#binds + 1] = {
      mode = 'i',
      key = string.format([[<M-%d>]], i),
      cmd = string.format([[<Esc><Cmd>exe "%dToggleTerm"<CR>]], i),
      opt = { silent = true },
    }
    binds[#binds + 1] = {
      mode = 't',
      key = string.format([[<M-%d>]], i),
      cmd = string.format([[<C-\><C-n><Cmd>exe "%dToggleTerm"<CR>]], i),
      opt = { silent = true },
    }
  end

  mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local term_maps = {
    ['<C-\\>'] = 'Toggle Current Terminal',
  }
  for i = 1, 3, 1 do
    term_maps[string.format([[<A-%d>]], i)] = string.format(
      'Toggle Terminal %d',
      i
    )
  end

  local which_keys = {
    {
      mapping = term_maps,
    },
  }

  which_key.bind_which_keys(which_keys)
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

  mappings.bind_buf_keys(0, binds)
end

function M.setup_custom()
  local Terminal = require('toggleterm.terminal').Terminal
  M.lazygit_term = Terminal:new({
    cmd = 'lazygit',
    direction = 'float',
    id = 1000,
  })
  M.ranger_term = Terminal:new({
    cmd = 'ranger',
    direction = 'float',
    id = 1001,
  })

  M.lazygit_toggle = M._lazygit_toggle
  M.ranger_toggle = M._ranger_toggle

  local binds = {
    {
      key = [[<M-4>]],
      cmd = string.format([[<cmd>lua %s<CR>]], M.plugin_fn('lazygit_toggle')),
      opt = { silent = true },
    },
    {
      key = [[<M-5>]],
      cmd = string.format([[<cmd>lua %s<CR>]], M.plugin_fn('ranger_toggle')),
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<M-4>]],
      cmd = string.format(
        [[<C-\><C-n><cmd>lua %s<CR>]],
        M.plugin_fn('lazygit_toggle')
      ),
      opt = { silent = true },
    },
    {
      mode = 't',
      key = [[<M-5>]],
      cmd = string.format(
        [[<C-\><C-n><cmd>lua %s<CR>]],
        M.plugin_fn('ranger_toggle')
      ),
      opt = { silent = true },
    },
  }

  mappings.bind_keys(binds)
end

function M._lazygit_toggle()
  M.lazygit_term:toggle()
end

function M._ranger_toggle()
  M.ranger_term:toggle()
end

return M
