local module = {}

local wezterm = require("wezterm")
local cwd = (...):match("(.-)[^%.]+$")

function module.apply(config)
  if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    local keys = require(cwd .. "key_mappings_linux")
    keys.apply(config)
  elseif wezterm.target_triple == "aarch64-apple-darwin" then
    local keys = require(cwd .. "key_mappings_mac")
    keys.apply(config)
  end
end

return module
