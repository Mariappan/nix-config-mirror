{
  pkgs,
  self,
  ...
}:
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
      source = self + /dotfiles/earthly_config.yml;
      target = ".earthly/config.yml";
    };
  };
}
