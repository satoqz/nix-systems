let
  imports = [
    ./internal
    ./programs
    ./services
  ];
in {
  nixosModules.default.imports = map (it: (import it).nixosModule) imports;
  darwinModules.default.imports = map (it: (import it).darwinModule) imports;
}
