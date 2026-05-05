{ self, ... }:
{
  flake.modules.nixos.desktop =
    { config, lib, ... }:
    let
      cfg = config.nixma.nixos.desktop;
    in
    {
      options.nixma.nixos.desktop.enable = lib.mkOption {
        type = lib.types.bool;
        default = lib.elem "workstation" config.nixma.nixos.roles;
        description = "Workstation desktop bundle (hidraw rules; pulls 1password/zen-browser via gui).";
      };

      config = lib.mkIf cfg.enable {
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
      # Mirror the NixOS-side `desktop.enable`. On darwin the namespace
      # doesn't exist; default to true so the workstation HM bundle still
      # applies there.
      isEnabled = osConfig.nixma.nixos.desktop.enable or true;
    in
    {
      imports = lib.optionals isEnabled [
        self.modules.homeManager.tmux
        self.modules.homeManager.nvim
        self.modules.homeManager.xdg
      ];

      config = lib.mkIf isEnabled {
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
