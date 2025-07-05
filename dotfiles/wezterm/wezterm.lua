local config = {}

local wezterm = require("wezterm")
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.automatically_reload_config = true
config.term = "wezterm"

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
  ["DELL U2724DE"] = 100,
  ["DELL U2422HE"] = 89,
  ["LG HDR WQHD"] = 100,
  ["LS27R75"] = 98,
}

-- and finally, return the configuration
return config
