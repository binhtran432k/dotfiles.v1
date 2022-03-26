-- cSpell:ignore folke
local M = {}

M.repo = 'folke/trouble.nvim'
M.name = 'trouble.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    cmd = { 'Trouble' },
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local trouble = require('trouble')
  trouble.setup({
    position = 'bottom', -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = 'workspace_diagnostics', -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = '', -- icon used for open folds
    fold_closed = '', -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = 'q', -- close the list
      cancel = '<esc>', -- cancel the preview and get back to your last window / buffer / cursor
      refresh = 'r', -- manually refresh
      jump = { '<cr>', '<tab>' }, -- jump to the diagnostic or open / close folds
      open_split = { '<c-x>' }, -- open buffer in new split
      open_vsplit = { '<c-v>' }, -- open buffer in new vsplit
      open_tab = { '<c-t>' }, -- open buffer in new tab
      jump_close = { 'o' }, -- jump to the diagnostic and close the list
      toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = 'P', -- toggle auto_preview
      hover = 'K', -- opens a small popup with the full multiline message
      preview = 'p', -- preview the diagnostic location
      close_folds = { 'zM', 'zm' }, -- close all folds
      open_folds = { 'zR', 'zr' }, -- open all folds
      toggle_fold = { 'zA', 'za' }, -- toggle fold of current file
      previous = 'k', -- preview item
      next = 'j', -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = { 'lsp_definitions' }, -- for the given modes, automatically jump if there is only a single result
    signs = {
      -- icons / text used for a diagnostic
      error = '',
      warning = '',
      hint = '',
      information = '',
      other = '﫠',
    },
    use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
  })
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<leader>xx',
      cmd = '<Cmd>Trouble<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>xw',
      cmd = '<Cmd>Trouble workspace_diagnostics<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>xd',
      cmd = '<Cmd>Trouble document_diagnostics<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>xl',
      cmd = '<Cmd>Trouble loclist<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>xq',
      cmd = '<Cmd>Trouble quickfix<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>xr',
      cmd = '<Cmd>Trouble lsp_references<CR>',
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
        ['<leader>x'] = {
          name = 'Trouble',
          x = 'Trouble',
          w = 'Trouble workspace',
          d = 'Trouble document',
          l = 'Trouble loclist',
          q = 'Trouble quickfix',
          r = 'Trouble LSP references',
        },
      },
    },
  }

  require('user.plugins.which-key_handler').bind_which_keys(which_keys)
end

return M
