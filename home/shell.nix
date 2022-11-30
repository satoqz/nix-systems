{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = {
      "cp" = "cp -v";
      "rm" = "rm -v";
      "mv" = "mv -v";
      "tmux" = "env TERM=screen-256color tmux";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = ''
        $username@$hostname $directory$git_branch$git_status$nix_shell
        $character
      '';
      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
        vicmd_symbol = "[v](bold green)";
      };
      username = {
        show_always = true;
        style_user = "bold green";
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false;
        style = "white";
        format = "[$hostname]($style)";
      };
      directory = { format = "[$path]($style) "; };
      git_branch = { format = "[$branch(:$remote_branch)]($style) "; };
      nix_shell = { format = "[*]($style) "; };
    };
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
    
      set -g mouse on

      set -g status-style default
      set -g status-position bottom
      
      set -g status-left ""
      set -g status-right ""

      setw -g window-status-current-format " #I #[fg=brightgreen]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' ) "
      setw -g window-status-format " #I #( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )"
    '';
  };

}
