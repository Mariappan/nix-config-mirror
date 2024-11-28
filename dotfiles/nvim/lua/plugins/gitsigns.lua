local plugin = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    local gs = require("gitsigns")
    gs.setup({
      signs = {
        add = { text = "┃" },
        change = { text = "┆" },
        delete = { text = "_", show_count = true },
        topdelete = { text = "‾", show_count = trur },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },
      numhl = false,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        virt_text_pos = 'eol',
      },
    })
  end,
}

return plugin
