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
    nr = "nix run";
    nb = "nix build";
    nf = "nix flake";
    ns = "nix shell";
    np = "nix profile";
  };

  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
  };

  programs.starship.settings = {
    add_newline = false;
    format = "$username[@](bright-black)$hostname$nix_shell ";
    right_format = "$git_status$directory$git_branch";
    username = {
      show_always = true;
      format = "[$user](white)";
    };
    hostname = {
      ssh_only = false;
      format = "[$hostname](white)";
    };
    directory.format = "[$path](green)";
    git_status.format = " ([<](bright-black)[$ahead_behind$all_status]($style)[>](bright-black)) ";
    git_branch.format = " [#](bright-black) [$branch(:$remote_branch)](white)";
    nix_shell.format = " [<](bright-black)[nix]($style)[>](bright-black)";
  };
}
