local M = {}

-- @table filetype_setups
-- @type table<string, function>
M.filetype_setups = {}

function M.setup()
  local options = {
    -- (( Color scheme ))
    termguicolors = true,
    background = 'dark',
    -- (( Column ruler ))
    colorcolumn = { 80, 100, 120 },
    -- (( Search case ))
    ignorecase = true,
    smartcase = true,
    -- (( Cursor ))
    -- cursorcolumn = true,
    -- cursorline = true,
    -- (( Cursor shape ))
    -- guicursor = 'n-c:block,i-ci-ve:ver40,r-cr-v:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175',
    -- guicursor = 'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
    -- guicursor = 'n-c:block',
    -- guifont = 'Delugia',
    -- (( Mouse selection ))
    mouse = 'a',
    -- (( Indent ))
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smarttab = true,
    -- (( Fold indent ))
    -- foldmethod = 'indent',
    foldlevelstart = 99,
    -- fillchars = 'fold: ',
    -- foldlevel = 99,
    foldmethod = 'expr',
    foldexpr = 'nvim_treesitter#foldexpr()',
    -- foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']],
    -- (( Increment priority ))
    nrformats = { 'alpha', 'bin', 'hex' },
    -- (( Line number ))
    number = true,
    relativenumber = true,
    -- (( LSP ))
    -- unicode characters in the file autoload/float.vim
    encoding = 'utf-8',
    -- TextEdit might fail if hidden is not set.
    hidden = true,
    -- Some servers have issues with backup files, see #649.
    backup = false,
    writebackup = false,
    -- Give more space for displaying messages.
    cmdheight = 2,
    -- showmode = false,
    -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    -- delays and poor user experience.
    updatetime = 250,
    -- (( Split window ))
    splitbelow = true,
    splitright = true,
    -- (( Spelling ))
    -- spell = true,
    spelllang = { 'en_us', 'vi' },
    spelloptions = 'camel',
    spellcapcheck = '', -- better for code checking
    -- spellfile = 'custom.utf-8.add',
    -- (( Others ))
    signcolumn = 'yes', -- display sign in column
    wrap = false, -- no wrap for long text
    scrolloff = 3, -- make cursor in middle
    sidescrolloff = 8,
    timeoutlen = 100, -- for which key
    completeopt = 'menu,menuone,noinsert', -- autocomplete menu
  }

  -- Don't pass messages to |ins-completion-menu|.
  vim.opt.shortmess:append('c')

  -- Highlight problematic whitespace, NOTE: Disable when terminal cursor is auto
  vim.opt.list = true
  vim.opt.listchars:append('tab:▸▸')
  vim.opt.listchars:append('trail:•')
  -- vim.opt.listchars:append('tab:»»')
  -- vim.opt.listchars:append('trail:•')
  -- vim.opt.listchars:append('extends:#')
  -- vim.opt.listchars:append('nbsp:.')
  -- vim.opt.listchars:append('space:⋅')
  -- vim.opt.listchars:append('eol:↴')

  -- vim.opt.listchars:append('tab:> ')
  -- vim.opt.listchars:append('space:.')

  -- Font
  -- local is_windows = vim.loop.os_uname().version:match('Windows')
  -- if is_windows then
  --   vim.g.guifont = 'Delugia:h12' -- Powerline font
  -- end

  -- Extend keyword
  vim.opt.iskeyword:append('-')

  -- Save last cursor position and folding
  vim.opt.viewoptions:remove('options')
  vim.cmd([[
  augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* if &ft !=# 'help' | mkview | endif
    autocmd BufWritePost *.* if &ft !=# 'help' | mkview | endif
    autocmd BufWinEnter *.* if &ft !=# 'help' | silent! loadview | endif
  augroup END
  ]])

  -- Auto reload content changed outside
  vim.cmd([[
  augroup auto_reload_content
    autocmd CursorHold,CursorHoldI * checktime
    autocmd FocusGained,BufEnter * :checktime
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  augroup END
  noremap ]s <cmd>lua require'spellsitter'.nav()<cr>
  ]])

  -- Disable automatic comment in newline
  -- vim.cmd [[
  -- autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  -- ]]

  for k, v in pairs(options) do
    vim.opt[k] = v
  end

  M.setup_builtin()
  M.setup_clipboard()
  M.load_filetype_setups()

  vim.cmd([[
  autocmd BufEnter * lua require("user.configs").load_filetype_setups()
  ]])
end

function M.setup_builtin()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_spec = 1
end

function M.setup_clipboard()
  vim.g.clipboard = {
    name = 'myClipboard',
    copy = {
      ['+'] = 'xclip -quiet -i -selection clipboard',
      ['*'] = 'xclip -quiet -i -selection clipboard',
    },
    paste = {
      ['+'] = 'xclip -o -selection clipboard',
      ['*'] = 'xclip -o -selection clipboard',
    },
    cache_enabled = 1,
  }
end

--- Register filetype setup
---@param filetype string
---@param label string
---@param func string
function M.register_filetype(filetype, label, func)
  if not M.filetype_setups[filetype] then
    M.filetype_setups[filetype] = {}
  end
  M.filetype_setups[filetype][label] = func
end

function M.load_filetype_setups()
  local filetype_setup = M.filetype_setups[vim.bo.filetype]
  if filetype_setup then
    for _, func in pairs(filetype_setup) do
      local f = load(func)
      f()
    end
  end
end

return M
