-- cSpell:ignore tpope
local configs = require('user.configs')
local which_key = require('user.plugins.which-key_handler')

local M = {}

M.repo = 'tpope/vim-fugitive'
M.name = 'vim-fugitive'
M.plugin_fn = function(_) end
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    cmd = { 'G', 'GBrowse' },
    requires = {
      { 'tpope/vim-rhubarb', after = M.name }, -- Fugitive-companion to interact with github
    },
  })

  M.plugin_fn = plugin_fn
  M.is_init = true

  return { filetype_setup = true }
end

function M.register_filetype_setup()
  if not M.is_init then
    return
  end

  configs.register_filetype('fugitive', 'fugitive', M.plugin_fn('filetype_setup'))
end

function M.filetype_setup()
  if not M.is_init then
    return
  end

  M.bind_buf_which_keys()
end

function M.bind_buf_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        s = { 'Stage' },
        u = { 'UnStage' },
        ['-'] = { 'Toggle stage' },
        U = { 'UnStage all' },
        X = { 'Discard change' },
        ['='] = { 'Toggle inline diff' },
        ['>'] = { 'Insert inline diff' },
        ['<'] = { 'Remove inline diff' },
        I = { 'git add/reset --patch' },
        d = {
          name = '+Diff',
          p = { 'git diff' },
          d = { 'git diff split' },
          v = { 'git diff vsplit' },
          s = { 'git diff hsplit' },
          h = { 'git diff hsplit' },
          q = { 'Close all diff buffer' },
          ['?'] = { 'Show help' },
        },
        ['<CR>'] = { 'Open' },
        o = { 'Open split' },
        O = { 'Open tab' },
        p = { 'Preview' },
        ['~'] = { 'Open ancestor' },
        P = { 'Open parent' },
        C = { 'Open commit' },
        ['('] = { 'Jump prev' },
        [')'] = { 'Jump next' },
        ['['] = {
          name = '+Nav prev',
          c = { 'Jump prev hunk' },
          ['/'] = { 'Jump prev file + collapse diff' },
          m = { 'Jump prev file + collapse diff' },
          ['['] = { 'Jump sections backward' },
          [']'] = { 'Jump sections end backward' },
        },
        [']'] = {
          name = '+Nav next',
          c = { 'Jump next hunk' },
          ['/'] = { 'Jump next file + collapse diff' },
          m = { 'Jump next file + collapse diff' },
          [']'] = { 'Jump sections forward' },
          ['['] = { 'Jump sections end forward' },
        },
        i = { 'Jump next + expand diff' },
        ['*'] = { 'Search diff line forward' },
        ['#'] = { 'Search diff line backward' },
        g = {
          name = '+Nav',
          u = { 'Jump Untracked/UnStaged' },
          U = { 'Jump UnStaged' },
          s = { 'Jump Staged' },
          p = { 'Jump UnPushed' },
          P = { 'Jump UnPulled' },
          r = { 'Jump Rebasing' },
          i = { 'Open split .git/info/exclude' },
          I = { 'Open split .git/info/exclude + add file' },
          O = { 'Open vsplit' },
          q = { 'Close status buffer' },
          ['?'] = { 'Show help' },
        },
        c = {
          name = '+Commit',
          c = { 'Create commit' },
          a = { 'Amend commit + edit' },
          e = { 'Amend commit' },
          w = { 'Reword last commit' },
          v = {
            name = '+with -v',
            c = { 'Create commit' },
            a = { 'Amend commit + edit' },
          },
          f = { 'fixup!' },
          F = { 'fixup! + rebase' },
          s = { 'squash!' },
          S = { 'squash! + rebase' },
          A = { 'squash! + edit' },
          ['<Space>'] = { ':Git commit' },
          r = {
            name = '+Revert',
            c = { 'Revert commit' },
            n = { 'Revert commit + not actual' },
            ['<Space>'] = { ':Git revert' },
          },
          m = {
            name = '+Merge',
            ['<Space>'] = { ':Git merge' },
          },
          ['?'] = { 'Show help' },
          b = {
            name = '+Branch',
            ['<Space>'] = { ':Git branch' },
            ['?'] = { 'Show help' },
          },
          o = {
            name = '+Checkout',
            o = 'Checkout commit',
            ['<Space>'] = { ':Git checkout' },
            ['?'] = { 'Show help' },
          },
          z = {
            name = '+Stash',
            z = { 'Push stash' },
            w = { 'Push stash WorkTree' },
            A = { 'Apply stash' },
            a = { 'Apply stash preserve' },
            P = { 'Pop stash' },
            p = { 'Pop stash preserve' },
            ['<Space>'] = { ':Git stash' },
            ['?'] = { 'Show help' },
          },
        },
        r = {
          name = '+Rebase',
          i = { 'Rebase interactive' },
          f = { 'Rebase auto squash' },
          u = { 'Rebase interactive upstream' },
          p = { 'Rebase interactive push' },
          r = { 'Continue rebase' },
          s = { 'Skip commit + continue rebase' },
          a = { 'Abort rebase' },
          e = { 'Edit rebase' },
          w = { 'Rebase interactive reword' },
          m = { 'Rebase interactive edit' },
          d = { 'Rebase interactive drop' },
          ['<Space>'] = { ':Git rebase' },
          ['?'] = { 'Show help' },
        },
        ['.'] = { 'Start : with file' },
      },
    },
  }

  which_key.bind_buf_which_keys(0, which_keys)
end

return M
