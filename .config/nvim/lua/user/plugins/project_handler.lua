-- cSpell:ignore ahmedkhalf
local M = {}

M.repo = 'ahmedkhalf/project.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    config = plugin_fn('setup'),
  })

  M.is_init = true

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local project = require('project_nvim')
  project.setup({
    ---@usage set to false to disable project.nvim.
    --- This is on by default since it's currently the expected behavior.
    active = true,

    on_config_done = nil,

    ---@usage set to true to disable setting the current-working directory
    --- Manual mode doesn't automatically change your root directory, so you have
    --- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,

    ---@usage Methods of detecting the root directory
    --- Allowed values: **'lsp'** uses the native neovim lsp
    --- **'pattern'** uses vim-rooter like glob pattern matching. Here
    --- order matters: if one is not detected, the other is used as fallback. You
    --- can also delete or rearrange the detection methods.
    -- detection_methods = { 'lsp', 'pattern' }, -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { 'pattern' },

    ---@usage patterns used to detect root dir, when **'pattern'** is in detection_methods
    patterns = {
      '.git',
      '_darcs',
      '.hg',
      '.bzr',
      '.svn',
      'Makefile',
      'package.json',
    },

    ---@ Show hidden files in telescope when searching for files in a project
    show_hidden = false,

    ---@usage When set to false, you will get a message when project.nvim changes your directory.
    -- When set to false, you will get a message when project.nvim changes your directory.
    silent_chdir = true,

    ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { 'efm', ... }
    ignore_lsp = {},

    ---@type string
    ---@usage path to store the project history for use in telescope
    datapath = vim.fn.stdpath('data'),
  })
end

function M.setup_telescope(telescope)
  if not M.is_init then
    return
  end

  telescope.load_extension('projects')
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {}
  ---@diagnostic disable-next-line: different-requires
  if require('user.plugins.telescope_handler').is_init then
    binds[#binds + 1] = {
      key = '<leader>fp',
      cmd = '<cmd>Telescope projects<cr>',
    }
  end
  require('user.mappings').bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {}
  if require('user.plugins.telescope_handler').is_init then
    which_keys[#which_keys + 1] = {
      mapping = {
        ['<leader>fp'] = 'Find projects',
      },
    }
  end
  require('user.plugins.which-key_handler').bind_which_keys(which_keys)
end

return M
