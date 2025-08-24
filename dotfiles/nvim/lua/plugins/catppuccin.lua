local plugin = {
  "catppuccin/nvim",
  config = function()
    local vim = vim
    vim.opt.termguicolors = true

    require("catppuccin").setup({
      transparent_background = true,
    })
  end,
}

return plugin
