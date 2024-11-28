local api = vim.api

local plugin = {
  "numtostr/FTerm.nvim",
  config = function()
    local map = require("mappings").map
    local fterm = require("FTerm")

    api.nvim_create_user_command("FTermToggle", fterm.toggle, { bang = true })

    map("n", "<C-`>", "<CMD>FTermToggle<CR>")
    map("t", "<C-`>", "<C-\\><C-n><CMD>FTermToggle<CR>")
  end,
}

return plugin
