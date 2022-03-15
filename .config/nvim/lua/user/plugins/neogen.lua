-- cSpell:ignore
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key')
local treesitter = require('user.plugins.treesitter')

local M = {}

M.repo = 'danymat/neogen'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    after = treesitter.name,
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end
  require('neogen').setup({
    enabled = true, --if you want to disable Neogen
    input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    -- jump_map = "<C-e>"       -- (DROPPED SUPPORT, see [here](#cycle-between-annotations) !) The keymap in order to jump in the annotation fields (in insert mode)
    snippet_engine = 'luasnip',
  })
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<Leader>cf',
      cmd = ":lua require('neogen').generate()<CR>",
      opt = { silent = true },
    },
    {
      key = '<Leader>cc',
      cmd = ":lua require('neogen').generate({ type = 'class' })<CR>",
      opt = { silent = true },
    },
    {
      key = '<Leader>ct',
      cmd = ":lua require('neogen').generate({ type = 'type' })<CR>",
      opt = { silent = true },
    },
    {
      key = '<Leader>ce',
      cmd = ":lua require('neogen').generate({ type = 'file' })<CR>",
      opt = { silent = true },
    },
  }

  mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<Leader>cf'] = 'Genrate function document',
        ['<Leader>cc'] = 'Genrate class document',
        ['<Leader>ct'] = 'Genrate type document',
        ['<Leader>ce'] = 'Genrate file document',
      },
    },
  }

  which_key.bind_which_keys(which_keys)
end

return M
