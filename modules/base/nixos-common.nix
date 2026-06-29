{ self, ... }:
{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      nixma.nixos.imported.common = true;

      imports = [
        self.modules.nixos.shared-nixpkgs
        self.modules.nixos.shared-homemanager
        self.modules.nixos.shared-shells
        self.modules.nixos.nix-settings
        self.modules.nixos.profile
        self.modules.nixos.agenix
        self.modules.nixos.hardware
        self.modules.nixos.boot
        self.modules.nixos.networking
        self.modules.nixos.network-services
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

      system.stateVersion = "26.05";
    };
}
