local wezterm = require("wezterm")

return {
   font = wezterm.font('Victor Mono'),
   color_scheme = "Dracula",
   font_size = 12,
   window_background_opacity = 0.9,
   hide_tab_bar_if_only_one_tab = true,
   enable_wayland = true,
   warn_about_missing_glyphs = false,
}
