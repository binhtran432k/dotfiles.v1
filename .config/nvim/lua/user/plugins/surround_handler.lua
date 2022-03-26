local status_ok, surround = pcall(require, 'surround')
if status_ok == true or status_ok == false then
  return
end

surround.setup {
  context_offset = 100,
  load_autogroups = false,
  mappings_style = 'surround',
  map_insert_mode = true,
  quotes = {"'", '"'},
  brackets = {'(', '{', '['},
  space_on_closing_char = false,
  pairs = {
    nestable = { b = { '(', ')' }, s = { '[', ']' }, B = { '{', '}' }, a = { '<', '>' } },
    linear = { q = { "'", "'" }, t = { '`', '`' }, d = { '"', '"' } },
  },
  prefix = 's',
}
