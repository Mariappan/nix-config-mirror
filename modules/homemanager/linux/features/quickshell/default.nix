{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./packages.nix # Caelestia scripts and quickshell wrapper derivations
  ];

  xdg.configFile = {
    "quickshell/caelestia" = {
      enable = true;
      source = ../../../../../dotfiles/caelestia;
      recursive = true;
    };
  };

  # Main packages
  home.packages = with pkgs; [
    config.programs.quickshell.finalPackage
    config.programs.beat_detector.finalPackage
    pkgs.nixma.caelestia

    # Runtime dependencies
    grim
    hyprpaper
    imagemagick
    wayfreeze
    wl-clipboard
    wl-screenrec
    libqalculate

    foot
    btop

    # Additional dependencies
    app2unit
    slurp
    swappy
    fuzzel
    lm_sensors
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
    inotify-tools
    cava
    networkmanager
    bluez
    ddcutil
    brightnessctl
  ];

  xdg.configFile.app2unit_env = {
    enable = true;
    target = "environment.d/999-app2unit.conf";
    text = "APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'\n";
  };

  # Systemd service
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "Caelestia desktop shell";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${config.programs.quickshell.finalPackage}/bin/qs -c caelestia";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
