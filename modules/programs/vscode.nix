{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.vscode.package =
    if pkgs.stdenv.isDarwin
    then (pkgs.runCommand "vscode-dummy" {} "mkdir $out")
    else pkgs.vscode;

  casks = lib.optional config.programs.vscode.enable "visual-studio-code";
}
