{
  programs.satty = {
    enable = true;

    settings = {
      general = {
        fullscreen = true;
        copy-command = "wl-copy";
        output-filename = "$XDG_PICTURES_DIR/Screenshots/Screenshot-%Y-%m-%d_%H:%M:%S.png";
      };
    };
  };
}
