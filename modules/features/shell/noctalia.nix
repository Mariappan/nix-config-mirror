{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    { config, lib, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
      };

      home.activation.noctalia-symlink =
        let
          dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles/noctalia";
          target = "${config.xdg.configHome}/noctalia";
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [[ -d ${target} && ! -L ${target} ]]; then
            run mv ${target} ${target}.pre-symlink
          fi
          run ln -sfn ${dotfiles} ${target}
        '';
    };
}
