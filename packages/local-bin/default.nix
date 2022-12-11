{
  config,
  stdenvNoCC,
  makeWrapper,
}:
stdenvNoCC.mkDerivation {
  pname = "local-bin";
  version = "main";

  src = ./bin;

  nativeBuildInputs = [makeWrapper];

  buildPhase = ''
    patchShebangs *
  '';

  installPhase = ''
    install -Dm755 -t $out/bin *
    wrapProgram $out/bin/use --set FLAKE_URL ${config.flakeUrl}
  '';
}
