local M = {}

function M.setup()
  -- Fix key mapping issues for GUI
  vim.api.nvim_set_keymap(
    'i',
    [[<S-Insert>]],
    [[<C-R>+]],
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'c',
    [[<S-Insert>]],
    [[<C-R>+]],
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'n',
    [[<C-6>]],
    [[<C-^>]],
    { noremap = true, silent = true }
  )

  -- Set Editor Font
  if vim.fn.exists(':GuiFont') then
    -- Use GuiFont! to ignore font errors
    vim.cmd('GuiFont Delugia:h12')
  end

  -- Disable GUI Tabline
  if vim.fn.exists(':GuiTabline') then
    vim.cmd('GuiTabline 0')
  end

  -- Disable GUI Popupmenu
  if vim.fn.exists(':GuiPopupmenu') then
    vim.cmd('GuiPopupmenu 0')
  end

  -- Enable GUI ScrollBar
  if vim.fn.exists(':GuiScrollBar') then
    vim.cmd('GuiScrollBar 1')
  end

  -- Right Click Context Menu (Copy-Cut-Paste)
  vim.api.nvim_set_keymap(
    'n',
    [[<RightMouse>]],
    [[:call GuiShowContextMenu()<CR>]],
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'i',
    [[<RightMouse>]],
    [[<Esc>:call GuiShowContextMenu()<CR>]],
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'x',
    [[<RightMouse>]],
    [[:call GuiShowContextMenu()<CR>gv]],
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    's',
    [[<RightMouse>]],
    [[<C-G>:call GuiShowContextMenu()<CR>gv]],
    { noremap = true, silent = true }
  )
end

return M
