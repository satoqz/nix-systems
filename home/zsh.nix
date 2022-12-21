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

  programs.zsh.initExtra = ''
    ZLE_RPROMPT_INDENT=0
  '';

  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
  };

  programs.starship.settings = {
    add_newline = false;

    format = "$hostname$directory$nix_shell[λ ](white)";

    hostname.format = "([\\(](bright-black)[host](cyan) [$hostname](white)[\\)](bright-black) )";
    directory.format = "([\\(](bright-black)[dir](green) [$path](white)[\\)](bright-black) )";
    nix_shell.format = "[\\(](bright-black)[\\$](blue)[\\)](bright-black) ";

    right_format = "$git_status$git_branch";

    git_status.format = "([\\(](bright-black)[$ahead_behind$all_status](red)[\\)](bright-black) )";
    git_branch.format = "([\\(](bright-black)[branch](cyan) [$branch](white)[\\)](bright-black))";
  };
}
