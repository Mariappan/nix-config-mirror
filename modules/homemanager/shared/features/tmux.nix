{pkgs, ...}: {
  programs.tmux.enable = true;
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.historyLimit = 20000;
  programs.tmux.keyMode = "vi";
  programs.tmux.mouse = true;
  programs.tmux.shortcut = "a";
  programs.tmux.baseIndex = 1;
  programs.tmux.shell = "${pkgs.fish}/bin/fish";
  programs.tmux.extraConfig = ''
    set -as terminal-features ",alacritty*:RGB"
    set -as terminal-overrides ",*:U8=0"

    set -g set-titles-string '#S:#I.#P #W'
    set -g @yank_selection 'primary'

    # Status
    set -g status "on"
    set -g status-bg "#303030"
    set -g status-justify "left"
    set -g status-right-length "100"
    set -g status-left-length "100"

    setw -g window-status-separator ""
    set -g status-interval 10

    set -g status-left "#[fg=#deddda] 【 #S 】"
    set -g status-right "#[fg=#deddda] 【 #h 】【 %Y-%m-%d %I:%M %p 】 "
    setw -g window-status-format " #I-#W "
    setw -g window-status-current-format "#[bg=#1d1d1d] #I-#W "

    setw -g status-style "fg=colour7"
    setw -ag status-style "bg=#4f4f4f
  '';
}
