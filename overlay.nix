{self, ...}: final: prev:
with prev; {
  local-bin = stdenvNoCC.mkDerivation {
    name = "local-bin";

    src = ./res/bin;

    buildPhase = ''
      patchShebangs *
    '';

    installPhase = ''
      install -Dm755 -t $out/bin *
    '';
  };
}
