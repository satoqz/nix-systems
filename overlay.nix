{self, ...}: final: prev: {
  local-bin = prev.stdenvNoCC.mkDerivation {
    name = "local-bin";
    src = ./res/bin;

    nativeBuildInputs = [prev.makeWrapper];

    buildPhase = ''
      patchShebangs *
    '';

    installPhase = ''
      install -Dm755 -t $out/bin *
      wrapProgram $out/bin/shadowflake --set FLAKE_URL '${self.config.flakeUrl}'
    '';
  };
}
