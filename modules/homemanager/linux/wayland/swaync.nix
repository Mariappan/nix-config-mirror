{ self, ... }:
{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile (self + /dotfiles/swaync/config.json));
    style = ''
      ${builtins.readFile (self + /dotfiles/swaync/style.css)}
    '';
  };
}
