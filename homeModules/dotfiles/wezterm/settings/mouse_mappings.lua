local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  config.mouse_bindings = {
    {
      event = { Down = { streak = 3, button = "Left" } },
      action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
      mods = "NONE",
    },
  }
end

return module
