local plugin = {
  "norcalli/nvim-colorizer.lua",
  config = function()
    local vim = vim
    vim.opt.termguicolors = true
    require("colorizer").setup({
      "css",
      "scss",
      "javascript",
      "typescript",
      "typescriptreact",
      "vim",
      "html",
    })
  end,
}

return plugin
