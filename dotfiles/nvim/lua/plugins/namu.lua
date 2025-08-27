local plugin = {
  "bassamsdata/namu.nvim",
  opts = {
    global = { },
    namu_symbols = { -- Specific Module options
      options = {
        AllowKinds = {
            rust = {
              "Function",
              "Method",
              "Module",
              "Property",
              "Variable",
              "Constant",
              "Enum",
              "Interface",
              "Field",
              "Struct",
            },
        },
      },
    },
  },
  keys = {
    { "<leader>ss", ":Namu symbols<cr>", mode = { "n" }, desc = "Jump to LSP symbol" },
    { "<leader>sw", ":Namu workspace<cr>", mode = { "n" }, desc = "Jump to LSP symbols - workspace" },
  },
}

return plugin
