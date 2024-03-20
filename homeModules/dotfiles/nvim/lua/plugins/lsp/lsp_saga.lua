local plugin = {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  depedencies = {
    "neovim/nvim-lspconfig",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local status, saga = pcall(require, "lspsaga")
    if not status then
      return
    end

    saga.setup({
      symbol_in_winbar = {
        enable = true,
        separator = "  ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
      },
    })

    local vim = vim
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    vim.keymap.set("n", "<C-k>", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
    vim.keymap.set("n", "gd", "<Cmd>Lspsaga goto_definition<CR>", opts)
    vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
    vim.keymap.set("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
    vim.keymap.set("n", "gR", "<Cmd>Lspsaga finder<CR>", opts)
    vim.keymap.set("n", "go", "<Cmd>Lspsaga outline<CR>", opts)
    vim.keymap.set("n", "ga", "<Cmd>Lspsaga code_action<CR>", opts)
  end,
}

return plugin
