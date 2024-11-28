local vim = vim

local notify = {
  'tim-harding/neophyte',
  tag = '0.2.5',
  event = 'VeryLazy',
  submodules = false,
  opts = {
    fonts = {
    {
      name = 'Victor Mono',
      features = {
        {
          name = 'calt',
          value = 1,
        },
        -- Shorthand to set a feature to 1
        'ss01',
        'ss02',
      },
    },
    -- Fallback fonts
    {
      name = 'MesloLGS NF',
      -- Variable font axes
      variations = {
        {
          name = 'slnt',
          value = -11,
        },
      },
    },
    -- Shorthand for no features or variations
    'Script12 BT',
    'Symbols Nerd Font',
    'Noto Color Emoji',
  },
  font_size = {
    kind = 'width', -- 'width' | 'height'
    size = 8,
  },
  -- Multipliers of the base animation speed.
  -- To disable animations, set these to large values like 1000.
  cursor_speed = 1,
  scroll_speed = 1,
  -- Increase or decrease the distance from the baseline for underlines.
  underline_offset = 1,
  },
}


local plugins = {
  notify,
}

return plugins
