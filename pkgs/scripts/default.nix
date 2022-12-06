{stdenvNoCC}:
stdenvNoCC.mkDerivation rec {
  pname = "scripts";
  version = "main";

  src = ./bin;

  buildPhase = ''
    patchShebangs *
  '';

  installPhase = ''
    install -Dm755 -t $out/bin *
  '';
}
