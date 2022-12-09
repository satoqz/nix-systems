{
  nixpkgs,
  flake-utils,
  ...
}: let
  packages = pkgs: {
    scripts = pkgs.callPackage ./scripts {};
  };
in
  {
    overlays.default = _: prev: {
      satoqz = packages prev.pkgs;
    };
  }
  // flake-utils.lib.eachDefaultSystem (
    system: {
      packages = packages (import nixpkgs {inherit system;});
    }
  )
