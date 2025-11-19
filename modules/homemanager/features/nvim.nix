{
  pkgs,
  inputs,
  self,
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
      source = self + /dotfiles/nvim;
      target = "nvim";
    };
  };
}
