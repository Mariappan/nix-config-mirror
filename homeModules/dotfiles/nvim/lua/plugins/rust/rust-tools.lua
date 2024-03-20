local dapui = {
  "rcarriga/nvim-dap-ui",
  config = function()
    require("dapui").setup()
  end,
}

local rust_tools = {
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            vim.lsp.inlay_hint.enable(bufnr, true)
          end,
        },
      }
    end,
  },
}

local plugins = {
  rust_tools,
}

return plugins
