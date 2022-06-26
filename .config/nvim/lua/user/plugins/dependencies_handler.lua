local M = {}

M.plenary = 'nvim-lua/plenary.nvim'
M.web_devicons = 'kyazdani42/nvim-web-devicons'
M.nonicons = 'yamatsum/nvim-nonicons'

M.web_devicons_name = 'nvim-web-devicons'

function M.init(use, _)
  use({
    M.web_devicons,
    -- requires = { M.web_devicons },
    module = M.web_devicons_name,
  })
end

return M
