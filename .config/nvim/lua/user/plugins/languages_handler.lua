-- cSpell:ignore preservim aklt MTDL9
local M = {}

M.is_init = false

function M.init(use, _)
  use({
    -- {
    --   'preservim/vim-markdown',
    --   ft = { 'markdown' },
    -- },
    { 'aklt/plantuml-syntax', ft = { 'plantuml' } },
    { 'MTDL9/vim-log-highlighting', ft = { 'log' } },
    { 'tfnico/vim-gradle', ft = { 'groovy' } },
    { 'SirJson/fzf-gitignore', ft = { 'gitignore' } },
  })

  M.is_init = true
end

return M
