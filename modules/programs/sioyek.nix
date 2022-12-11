{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.sioyek.package =
    lib.mkIf pkgs.stdenv.isDarwin
    (pkgs.runCommand "sioyek-dummy" {} "mkdir $out");

  casks = lib.optional config.programs.sioyek.enable "sioyek";

  home.packages = lib.optional (config.programs.sioyek.enable && pkgs.stdenv.isDarwin) (
    pkgs.runCommand "sioyek-${pkgs.sioyek.version}" {}
    "mkdir -p $out/bin && ln -s /Applications/sioyek.app/Contents/MacOS/sioyek $out/bin/sioyek"
  );
}
