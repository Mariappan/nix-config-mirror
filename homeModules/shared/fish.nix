args @ {pkgs, lib, ...}: {

  programs.fish = {
    enable = true;
    functions = {
      cdg = { # Cd to git root
        body = ''
        set -lx TOPLEVEL (git rev-parse --show-toplevel 2> /dev/null)
        if test $status -eq 0
          cd $TOPLEVEL
        end
        '';
      };
      _tide_item_nix_shell = { # displays nix shell env on the right of the prompt
        body = ''
        '';
      };
    };
    shellInit = ''
      ${lib.optionalString (!args ? osConfig) "source ${pkgs.nix}/etc/profile.d/nix-daemon.fish"}
    '';
    interactiveShellInit = ''
      set -g fish_greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source # use fish in nix run and nix-shell
      #tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Darkest --show_time='24-hour format' --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Many icons' --transient=No
      set -U tide_vi_mode_icon_visual V
    '';
    loginShellInit = ''
    ''
    + lib.optionalString (args ? darwinConfig) (let
      # fish path: https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635

      # add quotes and remove brackets '${XDG}/foo' => '"$XDG/foo"'
      dquote = str: "\"" + (builtins.replaceStrings ["{" "}"] ["" ""] str) + "\"";

      makeBinPathList = map (path: path + "/bin");
    in ''
      fish_add_path --move --prepend --path ${lib.concatMapStringsSep " " dquote (makeBinPathList args.darwinConfig.environment.profiles)}
      set fish_user_paths $fish_user_paths
    '');
    shellAliases = {
      icat = "kitty +kitten icat";
    };
    shellAbbrs = {
      ssh-keygen-ed25519 = "ssh-keygen -t ed25519";
      update-hardware-conf = "nixos-generate-config --show-hardware-config --no-filesystems > /etc/nixos/nixosModules/$(hostname)/hardware-configuration.nix && git -C /etc/nixos/ commit /etc/nixos/nixosModules/$(hostname)/hardware-configuration.nix -m \"$(hostname): update hardware-configuration.nix\"";
      nixos-update-flake = "pushd /etc/nixos && nix flake update && git commit -m \"nix flake update\" flake.lock && git push && popd";
    };
    plugins = with pkgs.fishPlugins; [

      {
        name = "tide"; # natively async
        #src = tide.src; # 5.6 on 23.11
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v6.0.1";
          sha256 = "sha256-oLD7gYFCIeIzBeAW1j62z5FnzWAp3xSfxxe7kBtTLgA=";
        };
      }
      {
        name = "puffer"; # adds "...", "!!" and "!$"
        src = puffer.src;
      }
      {
        name = "pisces"; # pisces # auto pairing of ([{"'
        src = pisces.src;
      }
      {
        name = "plugin-git"; # git abbrs
        #src = plugin-git.src;
        src = pkgs.fetchFromGitHub { # https://github.com/jhillyerd/plugin-git/pull/103
          owner = "hexclover";
          repo = "plugin-git";
          rev = "master";
          sha256 = "sha256-efKPbsXxjHm1wVWPJCV8teG4DgZN5dshEzX8PWuhKo4";
        };
      }
      {
        name = "done"; # doesn't work on wayland
        src = done.src;
      }
      # {
      #   name = "async-prompt"; # pisces # auto pairing of ([{"'
      #   src = async-prompt.src;
      # }
    ];
  };
}
