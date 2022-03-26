-- cSpell:ignore wbthomason
local M = {}

M.plugins = {
  -- (( Speedup ))
  'impatient',
  'filetype',
  -- (( Dependency lazy loading ))
  'dependencies',
  -- (( Startup Screen ))
  'alpha',
  -- (( Git ))
  'fugitive', -- Git commands in nvim
  'gitsigns', -- Add git related info in the signs columns and popups
  'git-blame',
  -- (( UI to select things (files, grep results, open buffers...) ))
  'telescope',
  'trouble',
  'dressing',
  -- (( Color scheme ))
  'dracula',
  'transparent',
  -- (( Auto completion ))
  'cmp',
  'autopairs',
  -- (( Status line ))
  'lualine',
  'bufferline',
  -- -- (( Terminal ))
  'toggleterm',
  -- (( File explorer ))
  'tree',
  -- (( Treesitter ))
  'treesitter',
  'ts_context',
  -- 'gps',
  'iswap',
  -- (( LSP ))
  'lsp',
  -- (( Debugging ))
  -- (( Indentation ))
  'indent-blankline', -- Add indentation guides even on blank lines
  'indent-o-matic', -- For fast auto detect indent
  -- (( Utils ))
  'comment',
  -- 'lightspeed',
  'hop',
  -- 'camel-case-motion',
  'wordmotion',
  'colorizer',
  'matchup',
  'neoscroll',
  'project',
  'todo-comments',
  'startuptime',
  'which-key',
  'sandwich',
  'textobj-user',
  'improves',
  'openbrowser',
  'spellsitter',
  'pretty-fold',
  'neogen',
  -- (( Highlight Syntax Fallback ))
  'languages',
  -- (( Extensions ))
  'vimtex',
  'rest',
  'markdown-preview',
  -- 'plantuml-preview',
}

function M.setup()
  M.auto_install()
  M.auto_sync()

  -- Use a protected call so we don't error out on first use
  local status_ok, packer = pcall(require, 'packer')
  if not status_ok then
    return
  end

  local use = packer.use

  packer.startup(function()
    -- (( Packer Manager ))
    use('wbthomason/packer.nvim')

    -- (( Plugins ))
    M.init_plugins(use, 'user.plugins', M.plugins)

    -- (( Debugging ))
    use('mfussenegger/nvim-dap') -- Debug Adapter Protocol
    use('rcarriga/nvim-dap-ui')
    use('theHamsta/nvim-dap-virtual-text')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      packer.sync()
    end
  end)
end

function M.init_plugins(use, plugin_dir, plugins)
  for _, plugin in ipairs(plugins) do
    local plugin_name = plugin_dir .. '.' .. plugin
    plugin_name = plugin_name .. '_handler'
    local plugin_fn = function(fn_name)
      return 'require("' .. plugin_name .. '").' .. fn_name .. '()'
    end
    local lazy_binds = require(plugin_name).init(use, plugin_fn)
    if lazy_binds then
      if lazy_binds.key then
        require('user.mappings').register_lazy(plugin_name)
      end
      if lazy_binds.which_key then
        require('user.plugins.which-key_handler').register_lazy(plugin_name)
      end
      if lazy_binds.filetype_setup then
        require(plugin_name).register_filetype_setup()
      end
    end
  end
end

-- Automatically install packer
function M.auto_install()
  local install_path = vim.fn.stdpath('data')
    .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    print('Installing packer close and reopen Neovim...')
    vim.cmd([[packadd packer.nvim]])
  end
end

function M.auto_sync()
  -- Auto command that reloads neovim whenever you save the plugins.lua file
  vim.cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost init.lua source <afile> | PackerSync
    augroup end
  ]])
end

return M
