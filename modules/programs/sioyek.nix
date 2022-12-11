{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.sioyek.package =
    if pkgs.stdenv.isDarwin
    then (pkgs.runCommand "sioyek-dummy" {} "mkdir $out")
    else pkgs.sioyek;

  casks = lib.optional config.programs.sioyek.enable "sioyek";
}
