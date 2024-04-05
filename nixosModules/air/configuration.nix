{lib, pkgs, home-manager, ...}: {

  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ../shared/common.nix
    ../shared/headless.nix
    ../shared/lanzaboote.nix
    ../shared/docker.nix
    ../shared/virtualbox.nix
  ];

  # System configs
  networking.hostName = "air";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Asia/Singapore";
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable XFCE4 Desktop Environment for RDP
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "xfce4-session";
  # services.xrdp.openFirewall = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.maari = {
    name = "maari";
    description = "Mariappan Ramasamy";
    home = "/home/maari";
    shell = "${pkgs.fish}/bin/fish";
    extraGroups = [ "wheel" "docker" "networkmanager" "vboxusers" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHYrhaeqkEaPmFxqfm8U26nBYU81cqPDTfd2PX96m0P"
    ];
  };
  nix.settings.trusted-users = [ "maari" ];
  security.sudo.extraRules = [
    {
      users = [ "maari" ];
      commands = [
        {
          command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  home-manager.users = {
    root = {
      imports = [
        ../../homeModules/shared/core.nix
        ../../homeModules/shared/nixos.nix
        ../../homeModules/shared/git
      ];
    };
    maari = {
      imports = [
        ../../homeModules/shared/core.nix
        ../../homeModules/shared/nixos.nix
        ../../homeModules/shared/xdg.nix
        ../../homeModules/shared/rust.nix
        ../../homeModules/shared/git
        ../../homeModules/shared/debug.nix
        {
          programs.git = {
            userName = "Mariappan Ramasamy";
            userEmail = "142216110+kp-mariappan-ramasamy@users.noreply.github.com";
            signing = {
              key = "09260E7E819CB52451171823FF801DC77426D7C1";
              signByDefault = true;
            };
          };
          home.sessionVariables = {
            EARTHLY_SSH_AUTH_SOCK = "/home/maari/.ssh/agent/1password.sock";
          };
        }
      ];
    };
  };
}

