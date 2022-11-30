{pkgs, ...}: {
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
}
