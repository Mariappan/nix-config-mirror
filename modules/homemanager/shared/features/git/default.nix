{ pkgs, ... }:
{
  home.packages = [
    pkgs.git-absorb
  ];

  programs.gitui.enable = true;
  programs.git.enable = true;
  programs.git.lfs.enable = true;
  programs.git.ignores = import ./ignores.nix;
  programs.git.settings = {
    alias = {
      graphviz = "!f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' \"$@\" | sed 's/[0-9a-f][0-9a-f]*/\"&\"/g' ; echo '}'; }; f";
      root = "rev-parse --show-toplevel";
      lss = "!f() { git ls-files -v . | grep ^S; }; f";
      rg = "!f()  { git log --all --pretty='format:%Cgreen%H %Cblue%s\n%b' --name-status -i --grep $1; }; f";
      rgs = "!f()  { git log --pretty='format:%Cgreen%H %Cblue%s' --name-status -i --grep $1; }; f";
    };
    core = {
      editor = "${pkgs.vim}/bin/vim";
      whitespace = "trailing-space,space-before-tab";
    };
    color = {
      ui = true;
      diff = {
        meta = 227;
        frag = "magenta bold";
        commit = "227 bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
      };
    };
    rerere = {
      enabled = true;
      autoupdate = true;
    };
    tag = {
      forceSignAnnotated = true;
    };
    push = {
      default = "simple";
    };
    init = {
      defaultBranch = "main";
    };
  };

  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
  programs.delta.options = {
    decorations = {
      commit-decoration-style = "bold yellow box ul";
      file-decoration-style = "none";
      file-style = "bold yellow ul";
    };
    features = "line-numbers decorations";
    whitespace-error-style = "22 reverse";
  };
}
