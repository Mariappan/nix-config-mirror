local module = {}

local wezterm = require("wezterm")
local act = wezterm.action

function module.apply(config)
  config.keys = {
    -- CMD-y starts `htop` in a new window
    -- {
    --   key = 'y',
    --   mods = 'CMD',
    --   action = wezterm.action.SpawnCommandInNewWindow {
    --     args = { '/opt/homebrew/bin/htop' },
    --   },
    -- },
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  }
end

return module
