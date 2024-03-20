local plugin = {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })
    local ts_comm = require("ts_context_commentstring.integrations.comment_nvim")
    local comm = require("Comment")
    comm.setup({
      pre_hook = ts_comm.create_pre_hook(),
    })
  end,
}

return plugin
