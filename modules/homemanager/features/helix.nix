{ ... }:
{
  home.sessionVariables = {
    EDITOR = "hx";
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "my-catppuccin-frappe";
      editor = {
        line-number = "absolute";
        mouse = true;
        gutters = [
          "diagnostics"
          "spacer"
          "line-numbers"
          "spacer"
          "diff"
        ];
        true-color = true;
        bufferline = "always";
        color-modes = true;
        insert-final-newline = true;
        auto-pairs = true;
        rulers = [
          80
          100
          110
          120
        ];
        text-width = 100;
        trim-trailing-whitespace = true;

        cursorcolumn = false;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker.hidden = false;

        lsp = {
          enable = true;
          display-messages = true;
          display-progress-messages = true;
          display-inlay-hints = true;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
      };
      keys.insert = {
        j.k = "normal_mode";
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };
    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "nix";
          language-servers = [ "nixd" ];
        }
      ];
      language-server.nixd.command = "nixd";
    };
    themes = {
      my-catppuccin-frappe = {
        inherits = "catppuccin_frappe";
        "ui.background" = { };
      };
      my-darcula = {
        inherits = "darcula";
        "ui.background" = { };
      };
    };
  };
}
