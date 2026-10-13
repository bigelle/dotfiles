-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font_size = 12
config.font = wezterm.font 'Fira Code'

config.enable_tab_bar = false

config.window_background_opacity = 0.7

config.color_scheme = 'carbonfox'

return config
