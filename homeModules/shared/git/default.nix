{pkgs, ...}: {
  home.packages = [
    pkgs.git-absorb
    pkgs.gnupg
  ];

  programs.git.enable = true;
  programs.git.ignores = import ./ignores.nix;
  programs.git.aliases = {
    graphviz = "!f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' \"$@\" | sed 's/[0-9a-f][0-9a-f]*/\"&\"/g' ; echo '}'; }; f";
    root = "rev-parse --show-toplevel";
    rg = "log --all --pretty=\"format:%Cgreen%H %Cblue%s\n%b%Creset\" --name-status --grep -i";
    rgs = "log --pretty=\"format:%Cgreen%H %Cblue%s%Creset\" --name-status --grep -i";
  };
  programs.gitui.enable = true;
  programs.git.delta.enable = true;
  programs.git.delta.options = {
    decorations = {
      commit-decoration-style = "bold yellow box ul";
      file-decoration-style = "none";
      file-style = "bold yellow ul";
    };
    features = "line-numbers decorations";
    whitespace-error-style = "22 reverse";
  };
  programs.git.extraConfig = {
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
}
