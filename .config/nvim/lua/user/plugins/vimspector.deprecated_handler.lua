local map = vim.api.nvim_set_keymap

map('n', '<leader>dl', ':call vimspector#Launch()<CR>', { noremap = true })
map('n', '<leader>ds', ':call vimspector#Reset()<CR>', { noremap = true })
map('n', '<leader>dc', ':call vimspector#Continue()<CR>', { noremap = true })

map(
  'n',
  '<leader>dt',
  ':call vimspector#ToggleBreakpoint()<CR>',
  { noremap = true }
)
map(
  'n',
  '<leader>dT',
  ':call vimspector#ClearBreakpoints()<CR>',
  { noremap = true }
)

map('n', '<leader>dr', '<Plug>VimspectorRestart', {})
map('n', '<leader>de', '<Plug>VimspectorStepOut', {})
map('n', '<leader>di', '<Plug>VimspectorStepInto', {})
map('n', '<leader>do', '<Plug>VimspectorStepOver', {})
