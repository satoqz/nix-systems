{
  lib,
  pkgs,
  ...
}: {
  programs.firefox.package =
    lib.mkIf pkgs.stdenv.isDarwin
    (pkgs.runCommand "firefox-dummy" {} "mkdir $out");
}
