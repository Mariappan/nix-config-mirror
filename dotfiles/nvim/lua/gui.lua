local Util = require("utils")

-- Set Gui options

vim.opt.guifont = { "Maple Mono:h11" }

-- Set colorscheme
vim.api.nvim_cmd({ cmd = "colorscheme", args = { "catppuccin-mocha" } }, {})

-- Disable vim.notify for 500ms
Util.lazy_notify()

if vim.g.neovide then
  -- vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1/1.25)
  end)
end

