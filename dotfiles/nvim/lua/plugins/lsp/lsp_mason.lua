local mason = {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end,
}

local mason_lsp = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "chapel-lang/mason-registry",
    "williamboman/mason.nvim",
  },
  config = function()
    local lsp = require("mason-lspconfig")
    lsp.setup({
      ensure_installed = {
        -- "lua_ls",
        -- "rust_analyzer",
        -- "yamlls",
      },
    })
  end,
}

local plugins = {
  mason,
  mason_lsp,
}

return plugins
