{ self, ... }:
{
  flake.modules.homeManager.hm-common =
    { ... }:
    {
      imports = with self.modules.homeManager; [
        fish
        htop
        helix
        vim
        dotfiles
      ];

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.stateVersion = "26.05";
    };
}
