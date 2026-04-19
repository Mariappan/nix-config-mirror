{ self, inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    { lib, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
      };

      home.activation.noctalia-symlinks =
        let
          dotfiles = builtins.toString (self + /dotfiles/noctalia);
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ln -sfn ${dotfiles}/settings.json ~/.config/noctalia/settings.json
          run ln -sfn ${dotfiles}/plugins.json ~/.config/noctalia/plugins.json
        '';
    };
}
