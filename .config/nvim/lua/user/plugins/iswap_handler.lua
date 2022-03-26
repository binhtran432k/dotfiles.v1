-- cSpell:ignore mizlan asdfghjklqwertyuiopzxcvbnm qwertyuiop
local M = {}

M.repo = 'mizlan/iswap.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    after = require('user.plugins.treesitter_handler').name,
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  ---@diagnostic disable-next-line: different-requires
  local iswap = require('iswap')
  iswap.setup({
    -- The keys that will be used as a selection, in order
    -- ('asdfghjklqwertyuiopzxcvbnm' by default)
    -- keys = 'qwertyuiop',

    -- Grey out the rest of the text when making a selection
    -- (enabled by default)
    -- grey = 'disable',

    -- Highlight group for the sniping value (asdf etc.)
    -- default 'Search'
    -- hl_snipe = 'ErrorMsg',

    -- Highlight group for the visual selection of terms
    -- default 'Visual'
    -- hl_selection = 'WarningMsg',

    -- Highlight group for the greyed background
    -- default 'Comment'
    -- hl_grey = 'LineNr',

    -- Automatically swap with only two arguments
    -- default nil
    -- autoswap = true
  })
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    { key = '<leader>A', cmd = '<Cmd>ISwapWith<CR>' },
    { key = '<leader>a', cmd = '<Cmd>ISwap<CR>' },
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
        ['<leader>A'] = 'Swap item with',
        ['<leader>a'] = 'Swap items',
      },
      mode = 'n',
    },
  }

  require('user.plugins.which-key_handler').bind_which_keys(which_keys)
end

return M
