-- cSpell:ignore lervag latexmk zathura mupdf okular
local which_key = require('user.plugins.which-key_handler')
local configs = require('user.configs')

local M = {}

M.repo = 'lervag/vimtex'
M.plugin_fn = function(_) end
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    ft = { 'tex' },
    setup = plugin_fn('pre_setup'),
    config = plugin_fn('setup'),
  })

  M.plugin_fn = plugin_fn
  M.is_init = true

  return { filetype_setup = true }
end

function M.pre_setup()
  -- Unset callback
  -- vim.g.vimtex_compiler_latexmk = {
  --   callback = 0,
  -- }

  -- Setup default pdf viewer

  -- ((Zathura))
  -- vim.g.vimtex_view_general_viewer = 'zathura'
  -- vim.g.vimtex_view_method = 'zathura'

  -- ((MuPdf))
  -- vim.g.vimtex_view_method = 'mupdf'

  -- ((Okular))
  vim.g.vimtex_view_general_viewer = 'okular'
  vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
end

function M.setup()
  if not M.is_init then
    return
  end
  -- Make main.tex as default latex project
  vim.cmd([[
  autocmd BufRead,FileType tex let b:vimtex_main = 'main.tex'
  ]])
end

function M.register_filetype_setup()
  if not M.is_init then
    return
  end

  configs.register_filetype('tex', 'vimtex', M.plugin_fn('filetype_setup'))
end

function M.filetype_setup()
  if not M.is_init then
    return
  end

  vim.b.vimtex_main = 'main.tex'
  M._bind_buf_which_keys()
end

function M._bind_buf_keys()
  local binds = {}

  require('user.mappings').bind_keys(binds)
end

function M._bind_buf_which_keys()
  local which_keys = {
    {
      mapping = {
        ['<localleader>l'] = { name = 'Vimtex' },
      },
      mode = 'n',
    },
  }

  which_key.bind_buf_which_keys(0, which_keys)
end

function M.fix_conflict()
  -- (( Fix vimtex ))
  vim.cmd([[
  autocmd FileType tex xmap ae <plug>(vimtex-ae)
  autocmd FileType tex xmap ie <plug>(vimtex-ie)
  autocmd FileType tex xmap ac <plug>(vimtex-ac)
  autocmd FileType tex xmap ic <plug>(vimtex-ic)
  ]])
end

return M
