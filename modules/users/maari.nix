{ self, inputs, ... }:
let
  sharedOptions =
    { lib, ... }:
    {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Mariappan Ramasamy";
        description = "Full name of the user";
      };

      email = lib.mkOption {
        type = lib.types.str;
        description = "Email address for git/jujutsu";
      };

      gitSigningKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "GPG key for git signing";
      };

      gitSignByDefault = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to sign commits by default";
      };

      sshKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "SSH authorized keys";
      };

      hmModules = lib.mkOption {
        type = lib.types.listOf lib.types.deferredModule;
        default = [ ];
        description = "HM feature modules for this user (set by host)";
      };
    };

  hmConfig =
    cfg:
    { lib, ... }:
    {
      imports = [
        self.modules.homeManager.hm-common
        inputs.nix-index-database.homeModules.nix-index
      ] ++ cfg.hmModules;

      config = {
        programs.git = {
          settings.user = {
            name = cfg.name;
            email = cfg.email;
          };
          signing = lib.mkIf (cfg.gitSigningKey != null) {
            key = cfg.gitSigningKey;
            signByDefault = cfg.gitSignByDefault;
          };
        };

        programs.jujutsu.settings = {
          user = {
            email = cfg.email;
            name = cfg.name;
          };
          signing = lib.mkIf (cfg.gitSigningKey != null) {
            key = cfg.gitSigningKey;
          };
          git = lib.mkIf cfg.gitSignByDefault {
            sign-on-push = true;
          };
        };
      };
    };
in
{
  # NixOS system-level user config
  flake.modules.nixos.user-maari =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.nixma.users.maari;
    in
    {
      options.nixma.users.maari = sharedOptions { inherit lib; } // {
        extraGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Additional groups for the user (added to default groups)";
        };
      };

      config = {
        users.users.maari = {
          name = "maari";
          home = "/home/maari";
          shell = "${pkgs.fish}/bin/fish";
          extraGroups = [
            "wheel"
            "dialout"
            "docker"
            "networkmanager"
            "vboxusers"
            "input"
          ] ++ cfg.extraGroups;
          isNormalUser = true;
          openssh.authorizedKeys.keys = cfg.sshKeys;
        };

        nix.settings.trusted-users = [ "maari" ];

        security.sudo.extraRules = [
          {
            users = [ "maari" ];
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];

        home-manager.users.maari = hmConfig cfg;

        # Configure 1Password polkit policy for this user
        programs._1password-gui.polkitPolicyOwners = lib.mkIf (config ? nixma.nixos."1password") [
          "maari"
        ];
      };
    };

  # Darwin system-level user config
  flake.modules.darwin.user-maari =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.nixma.users.maari;
    in
    {
      options.nixma.users.maari = sharedOptions { inherit lib; } // {
        username = lib.mkOption {
          type = lib.types.str;
          default = "maari";
          description = "System username (defaults to maari)";
        };
      };

      config = {
        users.users.${cfg.username} = {
          name = cfg.username;
          home = "/Users/${cfg.username}";
          openssh.authorizedKeys.keys = cfg.sshKeys;
        };

        nix.settings.trusted-users = [ cfg.username ];

        system.primaryUser = cfg.username;

        home-manager.users.${cfg.username} = hmConfig cfg;
      };
    };
}
