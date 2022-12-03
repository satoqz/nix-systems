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
}
