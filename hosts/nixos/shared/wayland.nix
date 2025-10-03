{ pkgs, ... }:
{
  programs.dconf.enable = true;

  # Ref: https://www.reddit.com/r/NixOS/comments/171mexa/polkit_on_hyprland/
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  security.pam.services = {
    # GreetD - regreet uses separate `greetd` PAM context
    # Disable Fingerprint/Yubikey for allowing to unlock Keyring
    greetd = {
      enableGnomeKeyring = true;
      u2fAuth = false;
      fprintAuth = false;
    };
    # noctalia-shell uses login pam context
    # for system-lock
    login = {
      enableGnomeKeyring = true;
    };
    hyprlock.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };

  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings = {
    default = [
      "com.mitchellh.ghostty"
      "org.wezfurlong.wezterm.desktop"
      "foot"
    ];
  };

  environment.systemPackages = [
    pkgs.libnotify
  ];

  fonts.packages = with pkgs; [
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    maple-mono.NF-unhinted
    # MesloLGS NF font
    nixma.meslolgsnf-font
    # Script12 BT font with custom sizing
    nixma.script12bt-font
  ];
}
