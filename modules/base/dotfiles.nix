{ ... }:
{
  flake.modules.homeManager.dotfiles =
    { config, lib, ... }:
    {
      options.dotfilesNonSandboxPath = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/nix-config/dotfiles";
        description = ''
          Path to the repo's non-sandboxed dotfiles directory. Used by
          home-manager activations that symlink runtime-editable configs
          (e.g. noctalia, niri) into ~/.config so they can be edited live
          without rebuilds. Override per-host if dotfiles live elsewhere.
        '';
      };

      config.nixma.imported.dotfiles = true;
    };
}
