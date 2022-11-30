{
  self,
  nixpkgs,
  ...
}: let
  mkPackages.common = pkgs: {
    scripts = pkgs.callPackage ./scripts {inherit (self) config;};
  };

  mkPackages.linux = pkgs: {
  };

  mkPackages.darwin = pkgs: {
  };
in {
  overlays.default = _: prev:
    with prev; {
      satoqz = self.lib.mergeAttrs (map (f: f pkgs) [
        mkPackages.common
        mkPackages.linux
        mkPackages.darwin
      ]);
    };

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
