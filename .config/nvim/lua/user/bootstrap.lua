local M = {}

function M.setup()
  require('user.globals').setup()
  require('user.plugins').setup()
  require('user.mappings').setup()
  if vim.g.readonly_mode ~= 1 then
    require('user.configs').setup()
  else
    require('user.configs').setup_readonly()
    vim.cmd([[
      map <silent> q :qa!<CR>
      map <silent> i :qa!<CR>
      map <silent> x :qa!<CR>
      map <silent><nowait> a <Nop>
      map <silent><nowait> d <C-d>
      map <silent><nowait> u <C-u>
      map <silent><nowait> c <Nop>
    ]])
  end
  -- require('user.scripts')
  require('user.ibus').setup()
  -- require('user.vietnamese-keymap').setup()
  require('user.fix-conflicts').setup()
end

return M
