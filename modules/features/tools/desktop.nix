{ self, ... }:
{
  flake.modules.nixos.desktop =
    { config, lib, ... }:
    let
      isWorkstation = lib.elem "workstation" config.nixma.nixos.roles;
    in
    {
      config = lib.mkIf isWorkstation {
        # Grant input group access to hidraw devices (gaming peripherals,
        # programmable keyboards, controllers).
        services.udev.extraRules = ''
          KERNEL=="hidraw*", GROUP="input", TAG+="uaccess"
        '';
      };
    };

  flake.modules.homeManager.desktop =
    {
      osConfig,
      pkgs,
      lib,
      ...
    }:
    let
      isWorkstation = lib.elem "workstation" (osConfig.nixma.nixos.roles or [ "workstation" ]);
    in
    {
      imports = lib.optionals isWorkstation [
        self.modules.homeManager.tmux
        self.modules.homeManager.nvim
        self.modules.homeManager.xdg
      ];

      config = lib.mkIf isWorkstation {
        home.packages = [
          pkgs.python3
          pkgs.rsync
          pkgs.wget
        ];

        programs.atuin = {
          enable = true;
          enableFishIntegration = true;
          flags = [ "--disable-ctrl-r" ];
        };

        programs.command-not-found.enable = false;
        # nix-index-database will automatically be installed
        # https://github.com/nix-community/nix-index-database/blob/469ef53571ea80890c9497952787920c79c1ee6e/home-manager-module.nix#L23
        programs.nix-index = {
          enable = true;
          enableFishIntegration = true;
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
          config = {
            global.hide_env_diff = true;
          };
        };
      };
    };
}
