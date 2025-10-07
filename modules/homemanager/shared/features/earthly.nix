{ pkgs, ... }:
{
  home.packages = [
    pkgs.earthly
  ];

  home.sessionVariables = {
    EARTHLY_SSH_AUTH_SOCK = "$HOME/.ssh/agent/1password.sock";
  };

  home.file = {
    "earthly" = {
      enable = true;
      source = ../../../../dotfiles/earthly_config.yml;
      target = ".earthly/config.yml";
    };
  };
}
