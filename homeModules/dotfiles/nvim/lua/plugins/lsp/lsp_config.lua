local lsp_config = {
  "neovim/nvim-lspconfig",
  config = function()
    local nvim_lsp = require("lspconfig")
    local vim = vim

    local on_attach = function(client, bufnr)
      -- formatting
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("'Format", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end
    end

    nvim_lsp.lua_ls.setup({
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      },
      commands = {
        Format = {
          function()
            require("stylua-nvim").format_file()
          end,
        },
      },
    })

    -- Set up completion using nvim_cmp with LSP source
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    nvim_lsp.flow.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    nvim_lsp.tsserver.setup({
      on_attach = on_attach,
      filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      cmd = {
        "typescript-language-server",
        "--stdio",
      },
      capabilities = capabilities,
    })

    nvim_lsp.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- Show line diagnostics automatically in hover window
    vim.o.updatetime = 250
    -- vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = "●" },
      severity_sort = true,
    })

    -- Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
      },
      update_in_insert = true,
      float = {
        source = "always", -- Or "if_many"
      },
    })
  end,
}

local plugins = {
  lsp_config,
}

return plugins
