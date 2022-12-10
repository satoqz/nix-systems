{
  self,
  nixpkgs,
  ...
}: let
  # packages that work on all platforms
  mkPackages.common = pkgs: {
    local-bin = pkgs.callPackage ./local-bin {inherit (self) config;};

    firefox =
      if pkgs.stdenv.isDarwin
      then pkgs.runCommand "firefox-0.0.0" {} "mkdir $out"
      else pkgs.firefox;
  };

  # packages that exclusively work on linux
  mkPackages.linux = pkgs: {
  };

  # packages that exclusively work on darwin
  mkPackages.darwin = pkgs: {
  };
in {
  # all packages in an overlay
  overlays.default = _: prev:
    with prev;
      self.lib.mergeAttrs (map (f: f pkgs) [
        mkPackages.common
        mkPackages.linux
        mkPackages.darwin
      ]);

  # packages based on what platform is used
  packages = with self.lib;
    forAllSystems (system: let
      pkgs = pkgsFor system;
    in
      mkPackages.common pkgs
      // (
        if includes systems.darwin system
        then mkPackages.darwin pkgs
        else mkPackages.linux pkgs
      ));
}
