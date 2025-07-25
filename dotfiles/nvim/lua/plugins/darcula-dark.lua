local plugin = {
  "xiantang/darcula-dark.nvim",
  config = function()
    local vim = vim
    vim.opt.termguicolors = true

    require("darcula").setup({
      override = function(c)
        return {
          background =  "#002030",
          dark = "#000000"
        }
      end,
      opt = {
        integrations = {
          telescope = true,
          lualine = true,
          lsp_semantics_token = true,
          nvim_cmp = true,
          dap_nvim = true,
        },
      },
    })
  end,
}

return plugin
