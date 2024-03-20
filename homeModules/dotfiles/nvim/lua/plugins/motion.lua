local leap = {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  config = function()
    local leap = require("leap")
    leap.add_default_mappings()
  end,
}

-- Highlight current word, Enable cursorline after a second
local flit = {
  "ggandor/flit.nvim",
  event = "VeryLazy",
  config = function()
    local flit = require("flit")
    flit.setup({})
  end,
}

local plugins = {
  leap,
  flit,
}

return plugins
