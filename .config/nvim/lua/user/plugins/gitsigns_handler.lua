local dependencies_handler = require('user.plugins.dependencies_handler')
local which_key = require('user.plugins.which-key_handler')

local M = {}

M.repo = 'lewis6991/gitsigns.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    requires = dependencies_handler.plenary,
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local gitsigns = require('gitsigns')
  gitsigns.setup({
    signs = {
      add = {
        hl = 'GitSignsAdd',
        text = '│',
        numhl = 'GitSignsAddNr',
        linehl = 'GitSignsAddLn',
      },
      change = {
        hl = 'GitSignsChange',
        text = '│',
        numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn',
      },
      delete = {
        hl = 'GitSignsDelete',
        text = '_',
        numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn',
      },
      topdelete = {
        hl = 'GitSignsDelete',
        text = '‾',
        numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn',
      },
      changedelete = {
        hl = 'GitSignsChange',
        text = '~',
        numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn',
      },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    yadm = {
      enable = false,
    },
    on_attach = function(bufnr)
      local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend(
          'force',
          { noremap = true, silent = true },
          opts or {}
        )
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
      end

      -- Navigation
      map(
        'n',
        ']c',
        "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
        { expr = true }
      )
      map(
        'n',
        '[c',
        "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
        { expr = true }
      )

      -- Actions
      map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
      map('v', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
      map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
      map('v', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
      map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
      map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
      map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
      map(
        'n',
        '<leader>hb',
        '<cmd>lua require"gitsigns".blame_line{full=true}<CR>'
      )
      map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
      map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
      -- map('n', '<leader>hl', '<cmd>Gitsigns toggle_current_line_blame<CR>')
      map('n', '<leader>hx', '<cmd>Gitsigns toggle_deleted<CR>')

      -- Text object
      map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  })
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['[c'] = 'Previous hunk',
        [']c'] = 'Next hunk',
        ['<leader>h'] = {
          name = 'GitSigns',
          S = 'Stage buffer hunk',
          R = 'Reset buffer hunk',
          u = 'Undo stage hunk',
          p = 'Preview hunk',
          d = 'Open diff',
          D = 'Open diff change',
          b = 'Preview blame line',
          -- l = 'Toggle line blame',
          x = 'Toggle deleted',
        },
      },
    },
    {
      mapping = {
        ['<leader>h'] = {
          s = 'Stage hunk',
          r = 'Reset hunk',
        },
      },
      mode = { 'n', 'v' },
    },
    {
      mapping = {
        ih = 'inner gitsigns hunk',
      },
      mode = { 'o', 'x' },
    },
  }

  which_key.bind_which_keys(which_keys)
end

function M.get_lualine_branch(fmt)
  return { 'b:gitsigns_head', icon = '', fmt = fmt }
end

function M.get_lualine_diff(fmt)
  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end
  return { 'diff', source = diff_source, fmt = fmt }
end

return M
