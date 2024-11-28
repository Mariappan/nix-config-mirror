local plugin = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-github.nvim",
    "nvim-telescope/telescope-node-modules.nvim",
    "gnfisher/nvim-telescope-ctags-plus",
  },
  config = function()
    local map = require("mappings").map
    local telescope = require("telescope")
    local finders = require("telescope.builtin")
    local actions = require("telescope.actions")
    local sorters = require("telescope.sorters")

    telescope.setup({
      defaults = {
        -- borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
        prompt_prefix = " ❯ ",
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<ESC>"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-o>"] = function() end,
            ["<TAB>"] = actions.toggle_selection + actions.move_selection_next,
            ["<C-s>"] = actions.send_selected_to_qflist,
            ["<C-q>"] = actions.send_to_qflist,
          },
        },
        file_sorter = sorters.get_fzy_sorter,
        generic_sorter = sorters.get_fzy_sorter,
      },
      layout_config = {
        vertical = {
          prompt_position = "top",
        },
      },
      extensions = {
        fzy_native = {
          override_file_sorter = true,
          override_generic_sorter = true,
        },
      },
    })

    telescope.load_extension("gh")
    telescope.load_extension("node_modules")
    -- telescope.load_extension("fzy_native")

    function TelescopeOpen(fn)
      finders[fn]()
    end

    -- Ctrl-p = fuzzy finder
    map("n", "<Leader>f", "<CMD>lua TelescopeOpen('find_files')<CR>")

    -- Fuzzy find active buffers
    map("n", "<Leader>b", "<CMD>lua TelescopeOpen('buffers')<CR>")

    -- Search for string
    map("n", "<Leader>r", "<CMD>lua TelescopeOpen('live_grep')<CR>")

    -- Fuzzy find history buffers
    map("n", "<Leader>i", "<CMD>lua TelescopeOpen('oldfiles')<CR>")

    -- Fuzzy find changed files in git
    map("n", "<Leader>c", "<CMD>lua TelescopeOpen('git_status')<CR>")

    -- Fuzzy find register
    map("n", "<Leader>g", "<CMD>lua TelescopeOpen('registers')<CR>")

    -- Resume previous search
    map("n", "<Leader>'", "<CMD>lua TelescopeOpen('resume')<CR>")
  end,
}

return plugin
