-- cSpell:ignore
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')
local treesitter = require('user.plugins.treesitter_handler')

local M = {}

M.repo = 'danymat/neogen'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    after = treesitter.name,
    config = plugin_fn('setup'),
  })

  M.is_init = true and not _G.is_readonly_mode

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local i = require('neogen.types.template').item

  local my_java_doc = {
    { nil, '/**', { no_results = true, type = { 'class', 'func' } } },
    { nil, ' * $1', { no_results = true, type = { 'class', 'func' } } },
    { nil, ' */', { no_results = true, type = { 'class', 'func' } } },

    { nil, '/**' },
    { nil, ' * $1' },
    { nil, ' *' },
    {
      nil,
      string.format(' * @author %s', M.get_my_name()),
      { type = { 'class' } },
    },
    -- { nil, ' * @version 1.0.0', { type = { 'class' } } },
    -- {
    --   nil,
    --   string.format(' * @since %s', M.get_current_date_string()),
    --   { type = { 'class' } },
    -- },
    { nil, ' *' },
    { i.Parameter, ' * @param %s $1' },
    { i.ClassAttribute, ' * @property %s $1' },
    { i.Return, ' * @return $1' },
    { i.Throw, ' * @throws $1' },
    { nil, ' */' },
  }

  require('neogen').setup({
    enabled = true, --if you want to disable Neogen
    input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    -- jump_map = "<C-e>"       -- (DROPPED SUPPORT, see [here](#cycle-between-annotations) !) The keymap in order to jump in the annotation fields (in insert mode)
    snippet_engine = 'luasnip',
    languages = {
      java = {
        template = {
          annotation_convention = 'my_java_doc',
          my_java_doc = my_java_doc,
        },
      },
    },
    placeholders_hl = 'None',
  })
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    {
      key = '<Leader>cf',
      cmd = ":lua require('neogen').generate()<CR>",
      opt = { silent = true },
    },
    {
      key = '<Leader>cc',
      cmd = ":lua require('neogen').generate({ type = 'class' })<CR>",
      opt = { silent = true },
    },
    {
      key = '<Leader>ct',
      cmd = ":lua require('neogen').generate({ type = 'type' })<CR>",
      opt = { silent = true },
    },
    {
      key = '<Leader>ce',
      cmd = ":lua require('neogen').generate({ type = 'file' })<CR>",
      opt = { silent = true },
    },
  }

  mappings.bind_keys(binds)
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        ['<Leader>cf'] = 'Genrate function document',
        ['<Leader>cc'] = 'Genrate class document',
        ['<Leader>ct'] = 'Genrate type document',
        ['<Leader>ce'] = 'Genrate file document',
      },
    },
  }

  which_key.bind_which_keys(which_keys)
end

function M.get_my_name()
  return 'Tran Duc Binh'
end

function M.get_current_date_string()
  return os.date('%Y-%m-%d')
end

return M
