local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  config.font = wezterm.font_with_fallback({
    { family = "Victor Mono", weight = "Regular" },
    { family = "MesloLGS NF", weight = "Regular" },
    { family = "Fira Code", weight = "Medium" },
    { family = "Script12 BT", weight = "Regular" }, -- cursive font
  })

  config.font_size = 10.0
  config.line_height = 1.1
  config.font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = wezterm.font({
        family = "Script12 BT",
        weight = "Bold",
        style = "Italic",
        scale = 1,
      }),
    },
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font({
        family = "Script12 BT",
        weight = "DemiBold",
        style = "Italic",
        scale = 1,
      }),
    },
    {
      italic = true,
      intensity = "Normal",
      font = wezterm.font({
        weight = "Regular",
        family = "Script12 BT",
        style = "Italic",
        scale = 1.1,
      }),
    },
  }
end

return module
