local mappings = require('user.mappings')
local configs = require('user.configs')
local which_key = require('user.plugins.which-key_handler')
local dependencies_handler = require('user.plugins.dependencies_handler')

local M = {}

M.repo = 'NTBBloodbath/rest.nvim'
M.plugin_fn = function(_) end
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    ft = { 'http' },
    requires = { dependencies_handler.plenary },
    config = plugin_fn('setup'),
  })

  M.plugin_fn = plugin_fn
  M.is_init = true

  return { filetype_setup = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  require('rest-nvim').setup({
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Highlight request on run
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      -- toggle showing URL, HTTP info, headers at top the of result window
      show_url = true,
      show_http_info = true,
      show_headers = true,
    },
    -- Jump to request line on run
    jump_to_request = false,
    env_file = '.env',
    custom_dynamic_variables = {},
    yank_dry_run = true,
  })
end

function M.register_filetype_setup()
  if not M.is_init then
    return
  end

  configs.register_filetype('http', 'restclient', M.plugin_fn('filetype_setup'))
end

function M.filetype_setup()
  if not M.is_init then
    return
  end

  M.bind_buf_keys()
  M.bind_buf_which_keys()
end

function M.bind_buf_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<localleader>rr',
      cmd = '<Plug>RestNvim',
      opt = {
        noremap = false,
      },
    },
    {
      key = '<localleader>rp',
      cmd = '<Plug>RestNvimPreview',
      opt = {
        noremap = false,
      },
    },
    {
      key = '<localleader>rl',
      cmd = '<Plug>RestNvimLast',
      opt = {
        noremap = false,
      },
    },
  }

  mappings.bind_buf_keys(0, binds)
end

function M.bind_buf_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['[b'] = 'Prev BufferLine cycle',
        ['<localleader>r'] = {
          name = 'Rest client',
          l = 'Run last Rest',
          p = 'Preview Rest',
          r = 'Run Rest',
        },
      },
    },
  }

  which_key.bind_buf_which_keys(0, which_keys)
end

return M
