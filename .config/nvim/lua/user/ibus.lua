local M = {}

M.is_setup = false
-- M.us_engine = 'BambooUs::Candy'
M.us_engine = 'BambooUs'

function M.trigger_ibus_off()
  if not M.is_setup then
    do return end
  end

  -- Save current engine
  vim.g.ibus_prev_engine = vim.fn.system('ibus engine')
  -- Change engine to English (US)
  vim.cmd([[silent! execute '!ibus engine ' . g:ibus_us_engine]])
end

function M.trigger_ibus_on()
  if not M.is_setup then
    do return end
  end

  -- Get current engine
  local current_engine = vim.fn.system('ibus engine')
  -- Restore previous engine
  vim.cmd([[silent! execute '!ibus engine ' . g:ibus_prev_engine]])
  -- Assign previous engine if current engine is not English (US)
  if current_engine ~= vim.g.ibus_us_engine then
    vim.g.ibus_prev_engine = current_engine
  end
end

function M.setup()
  vim.g.ibus_us_engine = M.us_engine

  vim.cmd([[
  augroup ibus_handler
    " Restore engine for search
    autocmd CmdLineEnter [/?] silent lua require('user.ibus').trigger_ibus_on()
    autocmd CmdLineLeave [/?] silent lua require('user.ibus').trigger_ibus_off()
    autocmd CmdLineEnter \? silent lua require('user.ibus').trigger_ibus_on()
    autocmd CmdLineLeave \? silent lua require('user.ibus').trigger_ibus_off()
    " Restore engine if enter insert mode
    autocmd InsertEnter * silent lua require('user.ibus').trigger_ibus_on()
    " Make engine to English if leave insert mode
    autocmd InsertLeave * silent lua require('user.ibus').trigger_ibus_off()
    " Make engine off in startup
    autocmd VimEnter * silent lua require('user.ibus').trigger_ibus_off()
  augroup END
  ]])

  M.is_setup = true
end

return M
