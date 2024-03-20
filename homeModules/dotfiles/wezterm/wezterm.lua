local config = {}

local wezterm = require("wezterm")
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.automatically_reload_config = true
config.term = "wezterm"

config.enable_wayland = false
-- Fix this and enable it
config.warn_about_missing_glyphs = false

-- Apply settings
local settings = require("settings")
settings.apply(config)

-- Apply machine local settings
local mlocal = require("machine_local")
mlocal.apply(config)

-- Custom monitor settings
config.dpi_by_screen = {
  ["Built-in Retina Display"] = 144,
  ["X340 PRO 165"] = 100,
  ["DELL U2719DC"] = 100,
}

-- and finally, return the configuration
return config
