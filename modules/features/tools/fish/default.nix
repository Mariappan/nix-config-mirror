{
  flake.modules.homeManager.fish =
    args@{
      config,
      pkgs,
      lib,
      ...
    }:
    {
      nixma.imported.fish = true;

      programs.man.generateCaches = lib.mkIf (config.programs.man.package == null) (lib.mkForce false);

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
          _tide_item_cargotarget = {
            body = ''
              # Show active Rust cross-compile target (e.g. nix develop .#musl)
              if not set -q CARGO_BUILD_TARGET
                return
              end
              # Shorten e.g. x86_64-unknown-linux-musl -> (musl)
              set -l short (string split -r -m1 -f2 -- - $CARGO_BUILD_TARGET)
              _tide_print_item cargotarget '(' $short ')'
            '';
          };
          _tide_item_netns = {
            body = ''
              # echo $tide_right_prompt_items
              # set --append tide_right_prompt_items netns

              # set -lx tide_netns_color CCFF00
              # set -lx tide_netns_bg_color normal
              # set -U tide_netns_icon '<U+F0C53>'

              set output (ip netns identify)
              if not string length --quiet $output
                return
              end
              _tide_print_item netns $tide_netns_icon' ' $output
            '';
          };
        };

        shellInit = ''
          ${lib.optionalString (!args ? osConfig) "source ${pkgs.nix}/etc/profile.d/nix-daemon.fish"}
        '';

        interactiveShellInit = ''
          set -g fish_greeting

          # Tide: show active Rust cross-compile target after the rustc item.
          # Rebuilt from the universal list each start so tide wizard edits still apply.
          set -g tide_cargotarget_color CCFF00
          set -g tide_cargotarget_bg_color normal

          # Jujutsu: swap tide's `git` slot for the tide-item-jj plugin's `vcs`
          # item, which shows jj status in jj repos and git status otherwise.
          # Rebuilt from the universal list each start so wizard edits still apply.
          set -g tide_jj_color $tide_git_color_branch
          set -g tide_jj_bg_color $tide_git_bg_color
          set -g tide_jj_color_upstream $tide_git_color_upstream
          set -g tide_jj_color_added $tide_git_color_branch
          set -g tide_jj_color_copied $tide_git_color_staged
          set -g tide_jj_color_modified $tide_git_color_untracked
          set -g tide_jj_color_removed $tide_git_color_conflicted
          set -g tide_jj_color_renamed $tide_git_color_dirty
          if contains git $tide_left_prompt_items; and not contains vcs $tide_left_prompt_items
            set -g tide_left_prompt_items (string replace -- git vcs $tide_left_prompt_items)
          end

          if contains rustc $tide_right_prompt_items; and not contains cargotarget $tide_right_prompt_items
            set -l _items
            for _it in $tide_right_prompt_items
              set -a _items $_it
              test $_it = rustc; and set -a _items cargotarget
            end
            set -g tide_right_prompt_items $_items
          end
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
          ""
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

              set -l os (uname)
              if test "$os" = Darwin
                  # Add user local paths
                  fish_add_path ~/.local/bin
                  fish_add_path ~/.krew/bin
                  fish_add_path ~/.cargo/bin
                  fish_add_path /opt/homebrew/bin
                  fish_add_path ~/Applications/Bin
              else if test "$os" = Linux
                  # do things for Linux
              else
                  # do things for other operating systems
              end
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
          {
            name = "tide-item-jj"; # jj status in tide via `vcs` item
            src = pkgs.fetchFromGitHub {
              owner = "lucasadelino";
              repo = "tide-item-jj";
              rev = "e1150b7332b85149b468cb10c2844f082f33975b";
              hash = "sha256-vLSrHPoytZ/kXQh0Bp/4AWe8YLlyufRjepfXUAuWCB8=";
            };
          }
        ];
      };
    };
}
