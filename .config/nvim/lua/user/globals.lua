local M = {}

function M.setup()
  _G.rainbow_colors = {
    'Error',
    'String',
    'Special',
    'Number',
    'Keyword',
    'Conditional',
    'Statement',
  }
  _G.special_file_types = {
    'alpha',
    'fugitive',
    'help',
    'nerdtree',
    'NvimTree',
    'packer',
    'toggleterm',
    'TelescopePrompt',
  }
end

return M
