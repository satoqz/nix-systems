{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.firefox.package =
    lib.mkIf pkgs.stdenv.isDarwin
    (pkgs.runCommand "firefox-dummy" {} "mkdir $out");

  casks = lib.optional config.programs.firefox.enable "firefox";
}
