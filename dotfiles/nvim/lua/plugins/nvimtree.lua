-- Neovim tree
local plugin = {
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "NvimTreeToggle" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  config = true
}

return plugin
