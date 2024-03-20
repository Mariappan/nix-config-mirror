local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  local ui = require("settings.ui")
  local windecor = require("settings.windecor")
  local statusbar = require("settings.statusbar")
  local fonts = require("settings.fonts")
  local keys = require("settings.key_mappings")
  local mouse = require("settings.mouse_mappings")

  ui.apply(config)
  windecor.apply(config)
  statusbar.apply(config)
  fonts.apply(config)
  keys.apply(config)
  mouse.apply(config)
end

return module
