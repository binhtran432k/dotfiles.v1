-- cSpell:ignore akinsho
local dependencies_handler = require('user.plugins.dependencies_handler')
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')

local M = {}

M.repo = 'akinsho/bufferline.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    requires = { dependencies_handler.web_devicons },
    event = 'BufRead',
    config = plugin_fn('setup'),
  })

  M.is_init = true and not _G.is_readonly_mode

  return { key = true, which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local bufferline = require('bufferline')
  bufferline.setup({
    options = {
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'File Explorer',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
      diagnostics = 'nvim_lsp', -- false | "nvim_lsp" | "coc"
    },
  })

  vim.cmd([[
  command! BufferOnly silent! execute "%bd|e#|bd#"
  ]])
end

function M.bind_keys()
  if not M.is_init then
    return
  end

  local binds = {
    -- These commands will navigate through buffers in order regardless of which mode you are using
    -- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
    {
      key = '[b',
      cmd = '<Cmd>BufferLineCyclePrev<CR>',
      opt = { silent = true },
    },
    {
      key = ']b',
      cmd = '<Cmd>BufferLineCycleNext<CR>',
      opt = { silent = true },
    },
    {
      key = '[B',
      cmd = '<Cmd>BufferLineMovePrev<CR>',
      opt = { silent = true },
    },
    {
      key = ']B',
      cmd = '<Cmd>BufferLineMoveNext<CR>',
      opt = { silent = true },
    },
    -- These commands will sort buffers by directory, language, or a custom criteria
    {
      key = '<leader>bb',
      cmd = '<Cmd>BufferLinePick<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>be',
      cmd = '<Cmd>BufferLineSortByExtension<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>bd',
      cmd = '<Cmd>BufferLineSortByDirectory<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>bi',
      cmd = '<Cmd>lua require("bufferline").sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>',
      opt = { silent = true },
    },
    {
      key = '<leader>ba',
      cmd = '<Cmd>BufferOnly<CR>',
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
        ['[b'] = 'Previous BufferLine cycle',
        [']b'] = 'Next BufferLine cycle',
        ['[B'] = 'Move previous BufferLine',
        [']B'] = 'Move next BufferLine',
        ['<leader>b'] = {
          name = 'BufferLine',
          a = 'Buffer only current',
          b = 'Bufferline Pick',
          e = 'Sort buffer by extension',
          d = 'Sort buffer by directory',
          i = 'Sort buffer by id',
        },
      },
    },
  }

  which_key.bind_which_keys(which_keys)
end

return M
