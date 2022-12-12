{
  config,
  stdenvNoCC,
  makeWrapper,
}:
stdenvNoCC.mkDerivation {
  pname = "local-bin";
  version = "main";

  src = ./bin;

  buildPhase = ''
    patchShebangs *
  '';

  installPhase = ''
    install -Dm755 -t $out/bin *
  '';
}
