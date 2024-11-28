local plugin = {
  "AckslD/nvim-neoclip.lua",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local clip = require("neoclip")
    clip.setup({})
    require("telescope").load_extension("neoclip")
  end,
}

return plugin
