final: prev:
with prev; {
  firefox =
    if stdenv.isDarwin
    then runCommand "firefox-dummy" {} "mkdir $out"
    else firefox;

  alacritty-mac-icon = stdenvNoCC.mkDerivation {
    name = "alacritty-mac-icon";

    src = ./res/alacritty.icns;

    unpackPhase = ''
      cp $src $(stripHash $src)
    '';

    installPhase = ''
      mkdir -p $out
      cp alacritty.icns $out
    '';
  };

  alacritty = alacritty.overrideAttrs (_: prevAttrs: {
    postInstall =
      prevAttrs.postInstall
      + lib.optionalString stdenv.isDarwin ''
        cp ${final.alacritty-mac-icon}/alacritty.icns $out/Applications/Alacritty.app/Contents/Resources
      '';
  });

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
