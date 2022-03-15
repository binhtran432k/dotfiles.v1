-- cSpell:ignore norcalli RRGGBB RRGGBBAA
local which_key = require('user.plugins.which-key')
local treesitter = require('user.plugins.treesitter')

local M = {}

M.repo = 'numToStr/Comment.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    after = treesitter.name,
    config = plugin_fn('setup'),
    keys = { 'gc', 'gb' },
  })

  M.is_init = true

  return { which_key = true }
end

function M.setup()
  if not M.is_init then
    return
  end

  local comment = require('Comment')
  local ft = require('Comment.ft')

  comment.setup({
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@param ctx Ctx
    pre_hook = function(ctx)
      -- Only calculate commentstring for tsx filetypes
      if vim.bo.filetype == 'typescriptreact' then
        local U = require('Comment.utils')

        -- Determine whether to use linewise or blockwise commentstring
        local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

        -- Determine the location where to calculate commentstring from
        local location = nil
        if ctx.ctype == U.ctype.block then
          location =
            require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location =
            require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring({
          key = type,
          location = location,
        })
      end
    end,
  })

  ft({ 'http' }, { '#%s' })
end

function M.bind_which_keys()
  if not M.is_init then
    return
  end

  local which_keys = {
    {
      mapping = {
        g = {
          c = {
            name = 'Comment linewise',
            c = 'Toggle line using linewise comment',
            o = 'Comment next line and enter Insert mode',
            O = 'Comment previous line and enter Insert mode',
            A = 'Comment to end line and enter Insert mode',
          },
          b = {
            name = 'Comment blockwise',
            c = 'Toggle line using blockwise comment',
          },
        },
      },
    },
    {
      mapping = {
        g = {
          b = 'Toggle line using blockwise comment',
          c = 'Toggle line using linewise comment',
        },
      },
      mode = 'v',
    },
  }

  which_key.bind_which_keys(which_keys)
end

return M
