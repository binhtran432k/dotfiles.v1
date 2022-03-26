local M = {}

M.plenary = 'nvim-lua/plenary.nvim'
M.web_devicons = 'kyazdani42/nvim-web-devicons'

M.web_devicons_name = 'nvim-web-devicons'

function M.init(use, _)
  use({
    M.repo,
    module = M.web_devicons_name,
  })
end

return M
