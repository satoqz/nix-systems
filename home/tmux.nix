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
    extraConfig = ''
      set -sa terminal-overrides ",xterm-256color:RGB"

      set -g renumber-windows on

      set -g mouse on

      set -g pane-active-border-style fg=brightblack
      set -g pane-border-style fg=brightblack

      set -g status-style default
      set -g status-position bottom

      set -g status-left ""
      set -g status-right "#[fg=brightblack]session: #[fg=white bold]#S  #[fg=brightblack]time: #[fg=white bold]#( date +'%H:%M' ) "

      setw -g window-status-current-format "#[fg=white bold]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' ) (#[fg=brightblack]#I#[fg=white bold])"
      setw -g window-status-format "#[fg=brightblack]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' ) (#[fg=green bold]#I#[fg=brightblack])"
    '';
  };

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    tmux = "env TERM=screen-256color tmux";
  };
}
