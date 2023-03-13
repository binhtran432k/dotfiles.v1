local wezterm = require("wezterm")

return {
   font = wezterm.font({
      family = 'Cascadia Code',
      harfbuzz_features = { 'calt', 'ss01' },
   }),
   color_scheme = "Dracula",
   font_size = 11,
   window_background_opacity = 0.9,
   hide_tab_bar_if_only_one_tab = true,
   enable_wayland = true,
   warn_about_missing_glyphs = false,
}
