{
  pkgs,
  lib,
  user,
  ...
}: {
  # darwin requires global zsh for things to link up properly
  programs.zsh.enable = lib.mkIf pkgs.stdenv.isDarwin true;

  users.users.${user}.shell = pkgs.zsh;
  environment.pathsToLink = ["/share/zsh"];

  home-manager.users.${user} = {
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
  };
}
