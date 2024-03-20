-- Auto Close parenthesis
local plugin = {
  --[[ Alt: windwp/nvim-autopairs ]]
  "m4xshen/autoclose.nvim",
  config = function()
    require("autoclose").setup()
  end,
}

return plugin
