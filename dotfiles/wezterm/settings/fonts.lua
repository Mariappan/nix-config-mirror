local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  config.font = wezterm.font_with_fallback({
    { family = "Maple Mono", weight = "Light" },
    { family = "Victor Mono", weight = "Regular" },
    { family = "MesloLGS NF", weight = "Regular" },
    { family = "Fira Code", weight = "Medium" },
    { family = "Script12 BT", weight = "Regular" }, -- cursive font
  })

  config.font_size = 10.5
  config.line_height = 1.0
  config.font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = wezterm.font({
        family = "Script12 BT",
        weight = "Bold",
        style = "Normal",
        scale = 1,
      }),
    },
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font({
        family = "Script12 BT",
        weight = "DemiBold",
        style = "Normal",
        scale = 1,
      }),
    },
    {
      italic = true,
      intensity = "Normal",
      font = wezterm.font({
        weight = "Regular",
        family = "Script12 BT",
        style = "Normal",
        scale = 1,
      }),
    },
  }
end

return module
