{
  flake.modules.nixos.nixGithubToken =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nixma.nixos.nixGithubToken;
    in
    {
      options.nixma.nixos.nixGithubToken = {
        file = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to the agenix-encrypted file containing a single `nix.conf` line
            of the form `access-tokens = github.com=ghp_...`. When set, the
            decrypted file is included into nix.conf at activation via
            `!include`, so the token never lands in the nix store.
          '';
        };

        owner = lib.mkOption {
          type = lib.types.str;
          default = "root";
          description = ''
            User that owns the decrypted token. Flake `github:` inputs are
            fetched by the nix client process (the invoking user), not the
            daemon, so that user must be able to read this file or the
            `!include` is silently skipped and the token never applies. Set to
            the primary login user for client-side flake operations.
          '';
        };
      };

      config = lib.mkIf (cfg.file != null) {
        nixma.nixos.imported.nixGithubToken = true;

        age.secrets.nix-github-token = {
          file = cfg.file;
          owner = cfg.owner;
          mode = "0400";
        };

        nix.extraOptions = ''
          !include ${config.age.secrets.nix-github-token.path}
        '';
      };
    };
}
