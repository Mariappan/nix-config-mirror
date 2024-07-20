{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../../dotfiles/swaync/config.json);
    style = ''
      ${builtins.readFile ../../dotfiles/swaync/style.css}
    '';
  };
}
