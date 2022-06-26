-- cSpell:ignore akinsho
-- local dependencies_handler = require('user.plugins.dependencies_handler')
-- local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')

local M = {}

M.repo = 'mfussenegger/nvim-dap'
M.name = 'nvim-dap'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    -- requires = { dependencies_handler.web_devicons },
    -- event = 'BufRead',
    config = plugin_fn('setup'),

    requires = {
      { 'theHamsta/nvim-dap-virtual-text', after = M.name },
      { 'rcarriga/nvim-dap-ui', after = M.name },
    },
  })

  M.is_init = true and vim.g.readonly_mode ~= 1

  return { key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  -- local dap = require('dap')
  require('dap')
  vim.cmd([[
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
  highlight! DapBreakpoint ctermfg=198 gui=bold guifg=#FF5555
  highlight! DapBreakpointRejected guifg=#FFB86C
  highlight! DapStopped ctermfg=198 guifg=#50fa7b
  highlight! DapLogPoint guifg=#191A21 guifg=#8BE9FD
  highlight! DapStoppedCursorLine cterm=underline guibg=#1f2d23
  ]])

  M.setup_sign()
end

function M.setup_sign()
  vim.fn.sign_define(
    'DapBreakpoint',
    -- { text = '🛑', texthl = '', linehl = '', numhl = '' }
    { text = '', texthl = 'ErrorMsg', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    -- { text = '🟢', texthl = '', linehl = '', numhl = '' }
    { text = '', texthl = 'Special', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapBreakpointCondition',
    -- { text = '🟡', texthl = '', linehl = '', numhl = '' }
    { text = '', texthl = 'WarningMsg', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapLogPoint',
    -- { text = '🔵', texthl = '', linehl = '', numhl = '' }
    { text = '', texthl = 'Keyword', linehl = '', numhl = '' }
  )
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  vim.cmd([[
  nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
  nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
  nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
  nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
  nnoremap <silent> <leader>dd :lua require'dap'.continue()<CR>
  nnoremap <silent> <leader>do :lua require'dap'.step_over()<CR>
  nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
  nnoremap <silent> <leader>de :lua require'dap'.step_out()<CR>
  nnoremap <silent> <leader>dt :lua require'dap'.toggle_breakpoint()<CR>
  nnoremap <silent> <leader>dc :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  nnoremap <silent> <leader>ds :lua require'dap'.clear_breakpoints()<CR>
  nnoremap <silent> <leader>dp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
  nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
  ]])

  -- mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  -- which_key.bind_which_keys(which_keys)
end

return M
