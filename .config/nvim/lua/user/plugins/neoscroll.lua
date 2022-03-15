-- cSpell:ignore karb94
local M = {}

M.repo = 'karb94/neoscroll.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'WinScrolled',
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local neoscroll = require('neoscroll')
  neoscroll.setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {
      '<C-u>',
      '<C-d>',
      '<C-b>',
      '<C-f>',
      '<C-y>',
      '<C-e>',
      'zt',
      'zz',
      'zb',
    },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil, -- Default easing function
    pre_hook = nil, -- Function to run before the scrolling animation starts
    post_hook = nil, -- Function to run after the scrolling animation ends
  })

  local t = {}
  -- Syntax: t[keys] = {function, {function arguments}}
  t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150' } }
  t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150' } }

  require('neoscroll.config').set_mappings(t)
end

return M
