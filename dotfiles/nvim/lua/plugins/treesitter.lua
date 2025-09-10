local plugin = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter.configs")
    -- stylua: ignore
    local langs = {
      "asm", "bash", "c", "c_sharp", "cpp", "cmake", "comment", "csv", "css", "devicetree", "diff",
      "disassembly", "dockerfile", "doxygen", "fish", "git_rebase", "gitattributes", "git_config",
      "gitignore", "go", "gomod", "gosum", "gotmpl", "gowork", "gpg", "hcl", "helm", "html",
      "http", "hurl", "java", "javascript", "jq", "json", "llvm", "lua", "luau", "markdown",
      "meson", "nasm", "ninja", "nix", "nu", "objdump", "passwd", "pem", "perl", "printf",
      "python", "readline", "regex", "rust", "sql", "ssh_config", "strace", "svelte",
      "terraform", "tmux", "toml", "tsv", "typescript", "udev", "vim", "vimdoc", "query",
      "xml", "yaml", "yang", "zig",
    }
    ts.setup({
      ensure_installed = langs,
      ignore_install = { "phpdoc" },
      highlight = {
        enable = true,
        -- use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      autotag = {
        enable = true,
      },
    })
  end,
}

return plugin
