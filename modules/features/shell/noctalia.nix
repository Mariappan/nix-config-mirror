{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixma.imported.noctalia = true;

      home.packages = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      home.activation.noctalia-symlink =
        let
          dotfiles = "${config.dotfilesNonSandboxPath}/noctalia";
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
