inputs: final: prev:
with prev; {
  satoqz = {
    hash = pkgs.callPackage ./hash {};
    scripts = pkgs.callPackage ./scripts {};
  };
}
