local Util = require("utils")

-- Set Gui options

-- vim.opt.guifont = { "Operator Mono Lig,MesloLGS NF", "h14" }

-- Set colorscheme
vim.api.nvim_cmd({ cmd = "colorscheme", args = { "darcula" } }, {})

-- Disable vim.notify for 500ms
Util.lazy_notify()
