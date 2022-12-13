{self, ...}: final: prev:
with prev; {
  local-bin = stdenvNoCC.mkDerivation {
    name = "local-bin";
    src = ./res/bin;

    nativeBuildInputs = [makeWrapper];

    buildPhase = ''
      patchShebangs *
    '';

    installPhase = ''
      install -Dm755 -t $out/bin *
      wrapProgram $out/bin/shadowflake --set FLAKE_URL '${self.config.flakeUrl}'
    '';
  };
}
