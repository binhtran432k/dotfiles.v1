local wezterm = require("wezterm")

return {
   font = wezterm.font({
      family = 'Maple Mono',
      harfbuzz_features = { 'calt', 'ss01' },
   }),
   color_scheme = "Dracula",
   font_size = 11,
   window_background_opacity = 0.9,
   hide_tab_bar_if_only_one_tab = true,
   enable_wayland = true,
   warn_about_missing_glyphs = false,
   unix_domains = {
     {
       name = 'unix',
     },
   },
   -- This causes `wezterm` to act as though it was started as
   -- `wezterm connect unix` by default, connecting to the unix
   -- domain on startup.
   -- If you prefer to connect manually, leave out this line.
   default_gui_startup_args = { 'connect', 'unix' }
}
