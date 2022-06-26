-- cSpell:ignore norcalli RRGGBB RRGGBBAA
local M = {}

M.repo = 'norcalli/nvim-colorizer.lua'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'CursorHold',
    config = plugin_fn('setup'),
  })

  M.is_init = true
end

function M.setup()
  if not M.is_init then
    return
  end

  local colorizer = require('colorizer')
  colorizer.setup(nil, {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
  })
end

return M
