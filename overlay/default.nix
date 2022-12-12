final: prev: {
  firefox =
    if prev.stdenv.isDarwin
    then prev.runCommand "firefox-dummy" {} "mkdir $out"
    else prev.firefox;

  alacritty-mac-icon = prev.stdenv.mkDerivation {
    name = "alacritty-mac-icon";

    src = ./alacritty.icns;

    unpackPhase = ''
      cp $src $(stripHash $src)
    '';

    installPhase = ''
      mkdir -p $out
      cp alacritty.icns $out
    '';
  };

  alacritty = prev.alacritty.overrideAttrs (_: prevAttrs: {
    postInstall =
      prevAttrs.postInstall
      + prev.lib.optionalString prev.stdenv.isDarwin ''
        cp ${final.alacritty-mac-icon}/alacritty.icns $out/Applications/Alacritty.app/Contents/Resources
      '';
  });

  local-bin = prev.stdenv.mkDerivation {
    name = "local-bin";
    version = "main";

    src = ./bin;

    buildPhase = ''
      patchShebangs *
    '';

    installPhase = ''
      install -Dm755 -t $out/bin *
    '';
  };
}
