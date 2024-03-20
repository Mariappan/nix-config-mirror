local plugin = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    local gs = require("gitsigns")
    gs.setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_", show_count = true },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
        --[[ untracked    = { text = '┆' }, ]]
      },
      numhl = false,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
    })
  end,
}

return plugin
