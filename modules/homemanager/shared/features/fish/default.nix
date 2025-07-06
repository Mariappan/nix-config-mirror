args@{
  pkgs,
  lib,
  ...
}:
{
  xdg.configFile = {
    "gitalias" = {
      enable = true;
      source = ./git.fish;
      target = "fish/conf.d/git.fish";
    };
    "lwfish" = {
      enable = true;
      source = ./lw.fish;
      target = "fish/functions/lw.fish";
    };
  };

  # home.activation = {
  #   fishTideAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #       run tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
  #   '';
  # };

  programs.fish = {
    enable = true;

    functions = {
      cdg = {
        # Cd to git root
        body = ''
          set -lx TOPLEVEL (git rev-parse --show-toplevel 2> /dev/null)
          if test $status -eq 0
            cd $TOPLEVEL
          end
        '';
      };
      git-current-branch = {
        body = ''
          set -f ref "$(command git symbolic-ref HEAD 2> /dev/null)"
          if test -z $ref
              return 1
          else
              echo (string replace refs/heads/ "" $ref)
              return 0
          end
        '';
      };
    };

    shellInit = ''
      ${lib.optionalString (!args ? osConfig) "source ${pkgs.nix}/etc/profile.d/nix-daemon.fish"}
    '';

    interactiveShellInit = ''
      set -g fish_greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source # use fish in nix run and nix-shell

      # Ctrl L - Clear the screen, but dont clear the scrollback
      bind \cl 'for i in (seq 1 $LINES); echo; end; clear; commandline -f repaint'
      bind \cw backward-kill-word

      # Modern tools
      if command -q bat
        alias cat "bat -p"
      end

      if command -q lsd
        alias ls="lsd"
      end

      if command -q nvim
        alias vim="nvim"
      end

      if command -q rbenv
        rbenv init - --no-rehash fish | source
      end

      abbr 4DIRS --set-cursor=! "$(string join \n -- 'for dir in */' 'cd $dir' '!' 'cd ..' 'end')"
    '';

    loginShellInit =
      ''''
      + lib.optionalString (args ? darwinConfig) (
        let
          # fish path: https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
          # add quotes and remove brackets '${XDG}/foo' => '"$XDG/foo"'
          dquote = str: "\"" + (builtins.replaceStrings [ "{" "}" ] [ "" "" ] str) + "\"";

          makeBinPathList = map (path: path + "/bin");
        in
        ''
          fish_add_path --move --prepend --path ${
            lib.concatMapStringsSep " " dquote (makeBinPathList args.darwinConfig.environment.profiles)
          }
          set fish_user_paths $fish_user_paths

          # Add user local paths
          fish_add_path ~/.local/bin
          fish_add_path ~/.krew/bin
          fish_add_path ~/.cargo/bin
          fish_add_path /opt/homebrew/bin
          fish_add_path ~/Applications/Bin
        ''
      );

    shellAliases = {
      icat = "kitty +kitten icat";
    };

    shellAbbrs = {
      ssh-keygen-ed25519 = "ssh-keygen -t ed25519";
      update-hardware-conf = "nixos-generate-config --show-hardware-config --no-filesystems > /etc/nixos/nixosModules/$(hostname)/hardware-configuration.nix && git -C /etc/nixos/ commit /etc/nixos/nixosModules/$(hostname)/hardware-configuration.nix -m \"$(hostname): update hardware-configuration.nix\"";
    };

    plugins = with pkgs.fishPlugins; [
      {
        name = "tide"; # Prompt PS1
        src = tide.src;
      }
      {
        name = "puffer"; # adds "...", "!!" and "!$"
        src = puffer.src;
      }
      {
        name = "pisces"; # pisces # auto pairing of bracket"'
        src = pisces.src;
      }
      {
        name = "colored_man_pages";
        src = colored-man-pages.src;
      }
      {
        name = "sudope";
        src = plugin-sudope.src;
      }
      {
        name = "done"; # doesn't work on wayland
        src = done.src;
      }
    ];
  };
}
