local module = {}

local wezterm = require("wezterm")
local act = wezterm.action

function module.apply(config)
  config.disable_default_key_bindings = true
  config.leader = { key = "a", mods = "CTRL" }
  config.keys = {
    -- CMD-y starts `top` in a new window
    {
      key = "y",
      mods = "CMD",
      action = wezterm.action.SpawnCommandInNewWindow({
        args = { "htop" },
      }),
      domain = "local",
    },

    { key = "J", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
    { key = "K", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "Enter", mods = "CTRL|SHIFT", action = act.ToggleFullScreen },

    -- Font resizing
    { key = ")", mods = "SHIFT|CTRL", action = act.ResetFontSize },
    { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },

    -- Clipboard
    { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
    {
      key = "U",
      mods = "SHIFT|CTRL",
      action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },
    { key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
    { key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },

    { key = "X", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },

    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
    { key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },

    -- Find
    { key = "F", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },

    -- Debug overlay
    -- { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },

    { key = "M", mods = "SHIFT|CTRL", action = act.Hide },

    -- Window management
    { key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
    { key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },

    -- Tab management
    { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },

    -- Pane management
    { key = "-", mods = "LEADER", action = act.SplitVertical },
    { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "Enter new name for tab",
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },

    -- CTRL+a, followed by 'r' will put us in resize-pane
    -- mode until we cancel that mode.
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "resize_pane",
        one_shot = false,
      }),
    },

    -- CTRL+a, followed by 'a' will put us in activate-pane
    -- mode until we press some other key or until 1 second (1000ms)
    -- of time elapses
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "activate_pane",
        one_shot = false,
      }),
    },
  }

  config.key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Escape", action = "PopKeyTable" },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    activate_pane = {
      { key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
      { key = "h", action = act.ActivatePaneDirection("Left") },

      { key = "RightArrow", action = act.ActivatePaneDirection("Right") },
      { key = "l", action = act.ActivatePaneDirection("Right") },

      { key = "UpArrow", action = act.ActivatePaneDirection("Up") },
      { key = "k", action = act.ActivatePaneDirection("Up") },

      { key = "DownArrow", action = act.ActivatePaneDirection("Down") },
      { key = "j", action = act.ActivatePaneDirection("Down") },

      -- Cancel the mode by pressing escape
      { key = "Enter", action = "PopKeyTable" },
    },

    search_mode = {
      { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
      { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
      { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
      { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
      { key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
      { key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
      { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
    },

    copy_mode = {
      { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
      { key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      { key = "g", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      {
        key = "y",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
      { key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
      { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
      { key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
    },
  }
end

return module
