{stdenvNoCC}:
stdenvNoCC.mkDerivation rec {
  pname = "darwin-utils";
  version = "main";

  src = ./bin;

  buildPhase = ''
    patchShebangs *
  '';

  installPhase = ''
    install -Dm755 -t $out/bin *
  '';
}
