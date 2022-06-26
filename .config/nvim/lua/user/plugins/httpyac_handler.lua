-- cSpell:ignore
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')
local configs = require('user.configs')

local M = {}

M.repo = '~/.config/nvim/testplugin/nvim-httpyac'
M.is_init = false
M.plugin_fn = function(_) end

function M.init(use, plugin_fn)
  use({
    M.repo,
    config = plugin_fn('setup'),
    ft = { 'http' },
  })

  M.plugin_fn = plugin_fn
  M.is_init = true

  return { filetype_setup = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local httpyac = require('nvim-httpyac')
  httpyac.setup()
end

function M.register_filetype_setup()
  if not M.is_init then
    return
  end

  configs.register_filetype(
    'http',
    'default',
    M.plugin_fn('filetype_setup')
  )
end

function M.filetype_setup()
  if not M.is_init then
    return
  end

  M._bind_buf_keys()
  M._bind_buf_which_keys()
end

function M._bind_buf_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<localleader>ll',
      cmd = '<Cmd>w|HttpRunLast<Cr>',
      opt = {
        silent = true,
      },
    },
    {
      key = '<localleader>lr',
      cmd = '<Cmd>w|HttpRun<Cr>',
      opt = {
        silent = true,
      },
    },
    {
      key = '<localleader>la',
      cmd = '<Cmd>w|HttpRunAll<Cr>',
      opt = {
        silent = true,
      },
    },
  }

  mappings.bind_buf_keys(0, binds)
end

function M._bind_buf_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<localleader>l'] = {
          name = 'Httpyac',
          l = 'Run last request',
          r = 'Run current request',
          a = 'Run all request',
        },
      },
    },
  }

  which_key.bind_buf_which_keys(0, which_keys)
end

return M
