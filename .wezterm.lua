-- Pull in the wezterm API
local wezterm                      = require 'wezterm'

-- This will hold the configuration.
local config                       = wezterm.config_builder()

config.automatically_reload_config = true

-- This is where you actually apply your config choices
-- For example, changing the color scheme:
config.color_scheme                = 'Catppuccin Latte'
config.use_fancy_tab_bar           = false

--- window
config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 0.8
config.window_padding = {
  left = 0,
  right = 13,
  top = 6,
  bottom = 6,
}
config.initial_cols = 130
config.initial_rows = 60

-- font
config.font = wezterm.font 'Maple Mono NF CN'
config.font_size = 12


config.enable_scroll_bar = true
config.tab_bar_at_bottom = true

-- and finally, return the configuration to wezterm
return config
