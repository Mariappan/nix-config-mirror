{ inputs, ... }:
{
  flake.modules.nixos.agenix =
    { pkgs, ... }:
    {
      imports = [ inputs.agenix.nixosModules.default ];

      nixma.nixos.imported.agenix = true;

      # Decrypt secrets with each host's SSH host key.
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      # ragenix CLI for editing/rekeying secrets on the host.
      environment.systemPackages = [ pkgs.ragenix ];
    };
}
