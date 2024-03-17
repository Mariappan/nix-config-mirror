{lib, pkgs, home-manager, ...}: {

  imports = [
    ./hardware-configuration.nix
    ../shared/common.nix
  ];

  # GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # System configs
  networking.hostName = "nixos"; # Define your hostname.
  time.timeZone = "Asia/Singapore";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  services.xrdp.openFirewall = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.nixuser = {
    name = "nixuser";
    home = "/home/nixuser";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P 1password"
    ];
  };
  nix.settings.trusted-users = [ "nixuser" ];
  security.sudo.extraRules = [
    {
      users = [ "nixuser" ];
      commands = [
        {
          command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  home-manager.users = let
    homeModule = {
      imports = [
        ../../homeModules/shared/core.nix
        ../../homeModules/shared/git
        {
          programs.git = {
            userName = "Mariappan Ramasamy";
            userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
            signing = {
              key = "09260E7E819CB52451171823FF801DC77426D7C1";
              signByDefault = true;
            };
          };
        }
      ];
    };
  in {
    root  = homeModule;
    nixuser = homeModule;
  };
}

