{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.tmux = {
    enable = lib.mkDefault true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 100000;
    disableConfirmationPrompt = true;
    terminal = "xterm-256color";
    extraConfig =
      ''
        set -sa terminal-overrides ",xterm-256color:RGB"

        set -g renumber-windows on

        set -g mouse on

        set -g pane-active-border-style fg=black
        set -g pane-border-style fg=black

        set -g status-style default
        set -g status-position bottom

        set -g status-left ""
        set -g status-right "#[fg=gray]#H #[fg=black][#[fg=brightred]#S#[fg=black]]"

        setw -g window-status-current-format "#[fg=black][#[fg=brightgreen]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=black]] "
        setw -g window-status-format "#[fg=black][#[fg=gray]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=black]] "
      ''
      + lib.optionalString pkgs.stdenv.isDarwin ''
        unbind -T copy-mode-vi MouseDragEnd1Pane
        bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-and-cancel\; run "tmux save-buffer - | pbcopy"
        unbind -T copy-mode-vi Enter
        bind -T copy-mode-vi Enter send -X copy-selection-and-cancel\; run "tmux save-buffer - | pbcopy"
      ''
      + lib.optionalString pkgs.stdenv.isLinux ''
        set -s set-clipboard on
      '';
  };

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    tmux = "env TERM=screen-256color tmux";
  };
}