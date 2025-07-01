{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./packages.nix          # Caelestia scripts and quickshell wrapper derivations
  ];

  xdg.configFile = {
    "quickshell/caelestia" = {
      enable = true;
      source = ../../../../dotfiles/caelestia;
      recursive = true;
    };
  };

  # Main packages
  home.packages = with pkgs; [
    config.programs.quickshell.finalPackage
    pkgs.nixma.caelestia

    # Qt dependencies
    qt6.qt5compat
    qt6.qtdeclarative

    # Runtime dependencies
    grim
    hyprpaper
    imagemagick
    wayfreeze
    wl-clipboard
    wl-screenrec

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
    cava
    networkmanager
    bluez
    ddcutil
    brightnessctl
    libqalculate
  ];

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
