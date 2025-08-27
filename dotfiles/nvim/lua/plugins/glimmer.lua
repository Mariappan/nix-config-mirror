local plugin = {
  "rachartier/tiny-glimmer.nvim",
  event = "VeryLazy",
  priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
  opts = {
    search = {
      enabled = false,
    },
    undo = {
      enabled = false,
    },
  },
}

return plugin
