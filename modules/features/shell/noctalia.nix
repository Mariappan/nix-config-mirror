{ self, inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    { pkgs, ... }:
    {
      nixma.imported.noctalia = true;

      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = builtins.readFile "${self}/dotfiles/noctalia/settings.toml";
      };
    };
}
