{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    coreutils
    curl
    wget
    htop
    gitui
    neofetch
    ripgrep
    jq

    satoqz.scripts
  ];

  programs.zsh.shellAliases = {
    "top" = "htop";
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "satoqz@pm.me";
    userName = "satoqz";
    extraConfig.init.defaultBranch = "main";
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
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

      set -g pane-active-border-style fg=black
      set -g pane-border-style fg=black

      set -g status-style default
      set -g status-position bottom

      set -g status-left ""
      set -g status-right "#[fg=gray]#H #[fg=gray][#[fg=brightred]#S#[fg=black]]"

      setw -g window-status-current-format "#[fg=black][#[fg=brightgreen]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=black]] "
      setw -g window-status-format "#[fg=black]#[fg=gray][#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=black]] "
    '';
  };
}
