-- cSpell:ignore akinsho
local M = {}

M.repo = 'nvim-telescope/telescope.nvim'
M.name = 'telescope.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    requires = {
      require('user.plugins.plenary').repo,
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        after = M.name,
        config = plugin_fn('setup_fzf'),
      },
    },
    cmd = { 'Telescope' },
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  require('telescope').setup({
    defaults = {
      path_display = { 'smart' },
      mappings = {
        i = {
          ['<C-h>'] = 'which_key',
        },
      },
      file_ignore_patterns = { 'node_modules/', '.git/' },
      -- layout_config = { prompt_position = 'top' },
      -- sorting_strategy = 'ascending',
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {
        additional_args = function(_)
          return { '--hidden' }
        end,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
      },
    },
  })
  require('user.plugins.project').setup_telescope(telescope)
end

function M.setup_fzf()
  if not M.is_init then
    return
  end

  -- Enable telescope fzf native
  ---@diagnostic disable-next-line: different-requires
  require('telescope').load_extension('fzf')
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  -- Default mapping
  local binds = {
    {
      key = '<leader>ff',
      cmd = '<Cmd>Telescope find_files<CR>',
    },
    {
      key = '<leader>fg',
      cmd = '<Cmd>Telescope live_grep<CR>',
    },
    {
      key = '<leader>fb',
      cmd = '<Cmd>Telescope buffers<CR>',
    },
    {
      key = '<leader>fh',
      cmd = '<Cmd>Telescope help_tags<CR>',
    },
  }
  require('user.mappings').bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<leader>f'] = {
          name = 'Telescope',
          f = 'Find files',
          g = 'Find files by live grep',
          b = 'Find buffers',
          h = 'Find helps',
        },
      },
    },
  }

  require('user.plugins.which-key').bind_which_keys(which_keys)
end

return M
