-- Setup Lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  spec = {
    -- Colorscheme creator
    { "rktjmp/lush.nvim", lazy = false, priority = 1000 },
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "plugins.editing" },
    { import = "plugins.ui" },
    { import = "plugins.rust" },
  },
  lockfile = "~/.local/share/nvim/lazy-lock.json",
  install = { colorscheme = { "habamax" } },
  checker = {
    enabled = true,
    frequency = 604800, -- 1 week (3600 * 24 * 7)
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
