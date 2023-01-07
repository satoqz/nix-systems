{
  description = "satoqz's nix configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixos.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager";
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

    eachSystem = f:
      builtins.listToAttrs (map (system: let
          pkgs = import nixpkgs {
            inherit system;
          };
        in {
          name = system;
          value = f system pkgs;
        })
        systems);

    mapValues = f: builtins.mapAttrs (_: value: f value);

    importTopLevel = mapValues (path: import path inputs);

    importPerSystem = mapValues (path:
      eachSystem (system: pkgs:
        import path (inputs
          // {
            inherit pkgs system;
          })));

    topLevel = importTopLevel {
      lib = ./lib.nix;

      nixosModules = ./nixos/modules;
      nixosConfigurations = ./nixos/configurations.nix;

      homeModules = ./home/modules;

      templates = ./templates;
    };

    perSystem = importPerSystem {
      packages = ./packages.nix;
      devShells = ./dev-shells.nix;

      homeConfigurations = ./home/configurations.nix;
    };

    extras = {
      formatter = eachSystem (_: pkgs: pkgs.alejandra);
    };
  in
    topLevel // perSystem // extras;
}
