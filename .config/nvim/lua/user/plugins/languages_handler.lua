local M = {}

M.is_init = false

function M.init(use, _)
  use({
    { 'aklt/plantuml-syntax', ft = { 'plantuml', 'markdown' } },
    { 'MTDL9/vim-log-highlighting', ft = { 'log' } },
    { 'tfnico/vim-gradle', ft = { 'groovy' } },
    { 'SirJson/fzf-gitignore', ft = { 'gitignore' } },
    { '~/.config/nvim/testplugin/vim-restclient-syntax', ft = { 'http' } },
  })

  M.is_init = true
end

return M
