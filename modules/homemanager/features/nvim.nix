{
  pkgs,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    withPython3 = true;
  };

  xdg.configFile = {
    "nvim" = {
      enable = true;
      source = ../../../dotfiles/nvim;
      target = "nvim";
    };
  };
}
