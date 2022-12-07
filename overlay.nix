inputs: {
  overlays.default = final: prev: {
    helix = inputs.helix.packages.${prev.pkgs.system}.default;
    satoqz = {
      hash = prev.pkgs.callPackage ./pkgs/hash {};
      scripts = prev.pkgs.callPackage ./pkgs/scripts {};
    };
  };
}
