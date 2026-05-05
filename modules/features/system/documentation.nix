{ self, ... }:
{
  flake.modules.nixos.documentation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      hasRole = role: lib.elem role config.nixma.nixos.roles;
    in
    {
      # Servers and SBCs typically don't need on-host docs (man pages, NixOS
      # manual, nix manual). Disable to drop ~50 MiB from the closure plus
      # man-db indexing on every rebuild.
      documentation.enable = lib.mkIf (hasRole "server") (lib.mkDefault false);

      # Workstations get the standard man-page corpora.
      environment.systemPackages = lib.mkIf (hasRole "workstation") [
        pkgs.man-pages
        pkgs.man-pages-posix
      ];
    };
}
