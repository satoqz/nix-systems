{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
  };

  programs.zsh.shellAliases = {
    cp = "cp -v";
    rm = "rm -v";
    mv = "mv -v";
  };

  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
  };

  programs.starship.settings = {
    add_newline = false;

    format = "$hostname$directory$nix_shell[λ ](white)";

    hostname.format = "[\\($hostname\\) ](bright-black)";
    directory.format = "[$path ](bold white)";
    nix_shell.format = "['](bold blue)";

    right_format = "$git_metrics$git_status$git_branch";

    git_metrics.disabled = false;
    git_status.format = "[$ahead_behind$all_status ](bright-black)";
    git_branch.format = "[$branch](bold white)";
  };
}
