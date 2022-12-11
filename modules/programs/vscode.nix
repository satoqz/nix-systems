{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.vscode.package =
    lib.mkIf pkgs.stdenv.isDarwin
    (pkgs.runCommand "vscode-dummy" {} "mkdir $out");

  casks = lib.optional config.programs.vscode.enable "visual-studio-code";
}
