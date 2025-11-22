{ ... }:
{
  nixma.hm.fish.enable = true;
  nixma.hm.htop.enable = true;
  nixma.hm.helix.enable = true;
  nixma.hm.vim.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
