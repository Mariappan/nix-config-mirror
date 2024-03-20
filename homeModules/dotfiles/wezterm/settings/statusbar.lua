local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  -- wezterm.on("update-right-status", function(window, pane)
  --       -- demonstrates shelling out to get some external status.
  --       -- wezterm will parse escape sequences output by the
  --       -- child process and include them in the status area, too.
  --       local success, date, stderr = wezterm.run_child_process({"date"});
  --
  --      -- However, if all you need is to format the date/time, then:
  --      date = wezterm.strftime("%Y-%m-%d %H:%M:%S");
  --
  --       -- Make it italic and underlined
  --       window:set_right_status(wezterm.format({
  --         {Attribute={Underline="Single"}},
  --         {Attribute={Italic=true}},
  --         {Text="Hello "..date},
  --     }));
  -- end);
  wezterm.on("update-right-status", function(window, pane)
    local name = window:active_key_table()
    if name then
      name = "TABLE: " .. name
    elseif true then
      name = "None "
    end
    window:set_right_status(wezterm.format({
      { Attribute = { Italic = true } },
      { Text = wezterm.nerdfonts.cod_calendar .. " " .. name },
    }))
    -- window:set_right_status(name or 'None ')
  end)
end

return module
