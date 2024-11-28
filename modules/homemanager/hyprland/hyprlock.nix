{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../../../dotfiles/hypr/hyprlock.conf}
    '';
  };
}
