{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.firefox.package =
    if pkgs.stdenv.isDarwin
    then (pkgs.runCommand "firefox-dummy" {} "mkdir $out")
    else pkgs.firefox;

  casks = lib.optional config.programs.firefox.enable "firefox";
}
