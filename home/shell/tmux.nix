{
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
    extraConfig = ''
      set -sa terminal-overrides ",xterm-256color:RGB"

      set -g renumber-windows on

      set -g mouse on

      set -g pane-active-border-style fg=white
      set -g pane-border-style fg=white

      set -g status-style default
      set -g status-position bottom

      set -g status-left ""
      set -g status-right "#[fg=white]#H [#[fg=brightred]#S#[fg=white]]"

      setw -g window-status-current-format "#[fg=white][#[fg=brightgreen]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=white]] "
      setw -g window-status-format "#[fg=white][#[fg=gray]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=white]] "
    '';
  };

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    tmux = "env TERM=screen-256color tmux";
  };
}
