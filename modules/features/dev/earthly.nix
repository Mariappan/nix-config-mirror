{ self, ... }:
{
  flake.modules.homeManager.earthly =
    { pkgs, ... }:
    {
      nixma.imported.earthly = true;

      home.packages = [
        pkgs.earthly
      ];

      home.sessionVariables = {
        EARTHLY_SSH_AUTH_SOCK = "$HOME/.ssh/agent/1password.sock";
      };

      home.file.".earthly/config.yml" = {
        text = ''
          global:
              cache_size_mb: 40000
              disable_analytics: true
              disable_log_sharing: true
        '';
      };
    };
}
