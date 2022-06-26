local M = {}

function M.setup()
  vim.cmd([[
  command! Vni set keymap=vietnamese-vni
  command! Telex set keymap=vietnamese-telex
  command! Eng set keymap=
  augroup keymap_handler
    " Restore engine for search
    autocmd CmdLineEnter [/?] silent setlocal timeoutlen=1000
    autocmd CmdLineLeave [/?] silent setlocal timeoutlen=100
    autocmd CmdLineEnter \? silent setlocal timeoutlen=1000
    autocmd CmdLineLeave \? silent setlocal timeoutlen=100
    " Restore engine if enter insert mode
    autocmd InsertEnter * silent setlocal timeoutlen=1000
    " Make engine to English if leave insert mode
    autocmd InsertLeave * silent setlocal timeoutlen=100
  augroup END
  ]])
end

return M
