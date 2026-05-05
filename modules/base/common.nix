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
      ];

      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      environment.systemPackages = [
        pkgs.ragenix
        pkgs.curl
        pkgs.file
        pkgs.iputils
        pkgs.helix
        pkgs.opensc
        pkgs.openssh
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

      system.stateVersion = "25.11";
    };
}
