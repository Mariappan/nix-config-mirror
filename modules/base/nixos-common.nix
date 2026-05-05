{ self, ... }:
{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        shared-nixpkgs
        shared-homemanager
        shared-shells
        nix-settings
        profile
        documentation
        agenix
        hardware
        boot
        networking
        laptop
        headless
        desktop
        kmscon
        remoteBuilders
        bluetooth
        fprint
        gui
        sound
        plymouth
        screenrecorder
        zen-browser
        _1password
        wayland
        niri
        hyprland
        veila
        gnome
        xserver
        xfce_rdp
        wayland-dm
        nautilus
        docker
        virtualbox
        incus
        nvidia
        yubikey
        lanzaboote
        vivaldi
        gpclient
      ];

      environment.systemPackages = [
        pkgs.curl
        pkgs.file
        pkgs.iputils
        pkgs.procps
        pkgs.usbutils
        pkgs.unzip
        pkgs.vim
        pkgs.zip
      ];

      security.pki.certificateFiles = [
        "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        (self + /dotfiles/certs/ca_homeolab.crt)
      ];

      # Internationalization settings
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      system.stateVersion = "25.11";
    };
}
