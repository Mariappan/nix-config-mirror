local nvim_context_vt = {
  "haringsrob/nvim_context_vt",
  event = "VeryLazy",
  config = function()
    local ctx = require("nvim_context_vt")
    ctx.setup({
      highlight = "ContextVt",
      disable_ft = { "markdown", "rust" },
    })
  end,
  enabled = true,
}

-- Highlight current word, Enable cursorline after a second
local nvim_cursorline = {
  "SirZenith/nvim-cursorline",
  event = "VeryLazy",
  config = function()
    local cur = require("nvim-cursorline")
    cur.setup({
      disable_in_mode = "[vVt]*",
      disable_in_filetype = { "TelescopePrompt" },
      disable_in_buftype = { "prompt" },
      disable_for_filename = {},
      default_timeout = 1000,
      cursorline = {
        enable = true,
        timeout = 500,
        no_line_number_highlight = false,
      },
      cursorword = {
        enable = true,
        timeout = 1000,
        min_length = 3,
        hl = { underline = true },
      },
    })
  end,
}

-- Winbar
local barbeque = {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  event = "VeryLazy",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  opts = {
    -- configurations go here
    theme = "monokai-pro",
  },
}

local plugins = {
  nvim_context_vt,
  nvim_cursorline,
  barbeque,
}

return plugins
