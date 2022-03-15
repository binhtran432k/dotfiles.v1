-- cSpell: ignore kyazdani42
local M = {}

M.repo = 'kyazdani42/nvim-web-devicons'

function M.init(use, _)
  use({
    M.repo,
    module = 'nvim-web-devicons',
  })
end

return M
