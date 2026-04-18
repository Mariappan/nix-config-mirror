{ self, ... }:
{
  flake.modules.homeManager.nvim = { pkgs, ... }:
    let
      treesitter-parsers = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.asm p.bash p.c p.c_sharp p.cpp p.cmake p.comment p.csv p.css
        p.devicetree p.diff p.disassembly p.dockerfile p.doxygen p.fish
        p.git_rebase p.gitattributes p.git_config p.gitignore p.go p.gomod
        p.gosum p.gotmpl p.gowork p.hcl p.helm p.html p.http p.hurl
        p.java p.javascript p.jq p.json p.llvm p.lua p.luau p.markdown
        p.meson p.nasm p.ninja p.nix p.nu p.objdump p.passwd p.pem p.perl
        p.printf p.python p.readline p.regex p.rust p.sql p.ssh_config
        p.strace p.svelte p.terraform p.tmux p.toml p.tsv p.typescript
        p.udev p.vim p.vimdoc p.query p.xml p.yaml p.yang p.zig
      ]);

      # Build a combined parser directory from all grammar plugins
      treesitter-parser-dir = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = treesitter-parsers.dependencies;
        postBuild = ''
          mkdir -p $out/parser
          for dir in $out/parser; do true; done
          # Collect all parser .so files into one directory
          rm -rf $out/parser
          mkdir -p $out/parser
          for dep in ${builtins.concatStringsSep " " (map (d: "${d}") treesitter-parsers.dependencies)}; do
            if [ -d "$dep/parser" ]; then
              for so in "$dep"/parser/*.so; do
                ln -sf "$so" "$out/parser/"
              done
            fi
          done
        '';
      };
    in
    {
      programs.neovim = {
        enable = true;
        withPython3 = true;
        plugins = [ treesitter-parsers ];
      };

      # Symlink treesitter parsers for nvim12 (NVIM_APPNAME=nvim12)
      home.file.".local/share/nvim12/site/parser".source = "${treesitter-parser-dir}/parser";

      # Minimal init.lua that loads nvim12-config as a plugin
      xdg.configFile."nvim/init.lua".source = self + /dotfiles/nvim-init.lua;
    };
}
