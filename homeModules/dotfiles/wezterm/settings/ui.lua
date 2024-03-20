local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  config.front_end = "WebGpu"

  config.color_scheme = "Afterglow (Gogh)"

  config.animation_fps = 60
  config.cursor_blink_ease_in = "Constant"
  config.cursor_blink_ease_out = "Constant"

  config.initial_rows = 48
  config.initial_cols = 120
end

return module
