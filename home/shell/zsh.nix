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
    format = "$username[@](white)$hostname$nix_shell ";
    right_format = "$git_status$directory$git_branch";
    username = {
      show_always = true;
      format = "[$user](gray)";
    };
    hostname = {
      ssh_only = false;
      format = "[$hostname](gray)";
    };
    directory.format = "[$path](gray)";
    git_status.format = " ([<](gray)[$ahead_behind$all_status](white)[>](gray)) ";
    git_branch.format = " [# $branch(:$remote_branch)](white)";
    nix_shell.format = " [<](gray)[nix](white)[>](gray)";
  };
}
