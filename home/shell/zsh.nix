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
    format = "$username@$hostname$nix_shell ";
    right_format = "$git_status$directory$git_branch";
    username = {
      show_always = true;
      format = "[$user](black)";
    };
    hostname = {
      ssh_only = false;
      format = "[$hostname](black)";
    };
    directory.format = "[$path](green)";
    git_status.format = " ([<](black)[$ahead_behind$all_status]($style)[>](black)) ";
    git_branch.format = " [# $branch(:$remote_branch)](black)";
    nix_shell.format = " [<](black)[nix]($style)[>](black)";
  };
}
