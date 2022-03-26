local indent_o_matic = require('user.plugins.indent-o-matic_handler')

local M = {}

M.lazy_plugins = {}
M.ft_plugins = {}

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.setup()
  -- Default key leader
  vim.g.mapleader = ','
  vim.g.maplocalleader = ';'

  local binds = {
    -- Real tab in insert
    { mode = 'i', key = '<S-Tab>', cmd = '<C-V><Tab>' },
    -- Window moving
    { key = '<C-h>', cmd = '<C-w>h' },
    { key = '<C-j>', cmd = '<C-w>j' },
    { key = '<C-k>', cmd = '<C-w>k' },
    { key = '<C-l>', cmd = '<C-w>l' },
    -- Resize pane
    { key = '<M-h>', cmd = '<Cmd>vertical resize -4<CR>' },
    { key = '<M-j>', cmd = '<Cmd>resize -4<CR>' },
    { key = '<M-k>', cmd = '<Cmd>resize +4<CR>' },
    { key = '<M-l>', cmd = '<Cmd>vertical resize +4<CR>' },
    -- Search a highlighted text
    { mode = 'v', key = '//', cmd = [[y/\V<C-R>=escape(@",'/\')<CR><CR>]] },
    -- Smart un-highlight with Enter
    {
      key = '<CR>',
      cmd = 'v:lua.require("user.mappings").smart_remove_highlight()',
      opt = { expr = true, silent = true },
    },
    {
      key = '<leader>R',
      cmd = '<Cmd>Refresh<CR>',
      opt = { silent = true },
    },
    -- Toggle Spelling
    {
      key = '<C-Space>',
      cmd = '<Cmd>set spell!<CR>',
      opt = { silent = true },
    },
  }

  vim.cmd([[
  command! Refresh lua require("user.mappings").refresh()
  command! W w|e
  ]])

  M.load_lazy_keys()
  M.bind_keys(binds)
end

function M.refresh()
  vim.cmd([[redraw!]])
  vim.cmd([[colorscheme dracula]])
  vim.cmd([[nohlsearch]])
  if indent_o_matic.is_init then
    vim.cmd([[IndentOMatic]])
  end
end

-- Remove Highlight text when press <cr> if there is
function M.smart_remove_highlight()
  if vim.opt.hlsearch['_value'] and vim.v.hlsearch == 1 then
    return t('<Cmd>nohlsearch<CR>')
  else
    return t('<CR>')
  end
end

function M.bind_keys(binds)
  for _, bind in ipairs(binds) do
    local modes = bind.mode or 'n'
    modes = type(modes) == 'table' and modes or { modes }
    local opt = bind.opt or {}
    opt.noremap = opt.noremap or true
    for _, mode in ipairs(modes) do
      vim.api.nvim_set_keymap(mode, bind.key, bind.cmd, opt)
    end
  end
end

function M.bind_buf_keys(bufnr, binds)
  for _, bind in ipairs(binds) do
    local modes = bind.mode or 'n'
    modes = type(modes) == 'table' and modes or { modes }
    local opt = bind.opt or {}
    opt.noremap = opt.noremap or true
    for _, mode in ipairs(modes) do
      vim.api.nvim_buf_set_keymap(bufnr, mode, bind.key, bind.cmd, opt)
    end
  end
end

function M.register_lazy(plugin)
  M.lazy_plugins[#M.lazy_plugins + 1] = plugin
end

function M.load_lazy_keys()
  local plugins = M.lazy_plugins
  for _, plugin in ipairs(plugins) do
    require(plugin).bind_keys()
  end
end

return M
