local ls = require('luasnip')
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.expand_conditions')

local LOREM = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod '
  .. 'tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At '
  .. 'vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, '
  .. 'no sea takimata sanctus est Lorem ipsum dolor sit amet.'

ls.add_snippets('all', {
  s({ trig = 'ymd', name = 'Current date', dscr = 'Insert the current date' }, {
    p(os.date, '%Y-%m-%d'),
  }),
  s(
    { trig = 'lorem%d?%d?%d?', name = 'Lorem Ipsum', regTrig = true },
    f(function(_, snip)
      if #snip.trigger == 5 then
        return LOREM
      end
      local lorem_len = LOREM:len()
      local result_len = tonumber(string.sub(snip.trigger, 6))
      local result = ''
      while result_len > lorem_len do
        result = result .. LOREM .. ' '
        result_len = result_len - lorem_len - 1
      end
      result = result .. string.sub(LOREM, 1, result_len)
      return result
    end, {})
  ),
})
