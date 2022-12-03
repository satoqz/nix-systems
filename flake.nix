{
  description = "satoqz's nix environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix";
  };

  outputs = { self, nixpkgs, utils, darwin, home-manager, ... }@inputs:
    let
      user = "satoqz";
      mkHost = { hostname, system, home ? [ ] }:
        let
          isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
        in
        (if isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem) {
          inherit system;
          specialArgs = { inherit self inputs user system hostname home isDarwin; };
          modules = [
            ./hosts/${hostname}
            { nixpkgs.overlays = [ self.overlays.default ]; }
            (
              self.${
              if isDarwin then "darwinModules" else "nixosModules"}.common
            )
          ] ++ nixpkgs.lib.optional (home != [ ])
            home-manager.${if isDarwin then "darwinModules" else "nixosModules"}.home-manager;
        };
    in
    {
      overlays.default = (final: prev: with prev.pkgs; {
        hash = callPackage ./pkgs/hash { };
        darwin-utils = callPackage ./pkgs/darwin-utils { };
        common-utils = callPackage ./pkgs/common-utils { };
      });

      nixosModules = {
        common = import ./modules/common;
      };

      darwinModules = {
        common = self.nixosModules.common;
      };

      nixosConfigurations = {
        tandoori = mkHost {
          hostname = "tandoori";
          system = "aarch64-linux";
          home = [
            ./home/shell.nix
            ./home/tools.nix
          ];
        };
        
        dopiaza = mkHost {
          hostname = "dopiaza";
          system = "x86_64-linux";
          home = [
            ./home/shell.nix
            ./home/tools.nix
            ./home/helix.nix
          ];
        };
      };

      darwinConfigurations = {
        korai = mkHost {
          hostname = "korai";
          system = "aarch64-darwin";
          home = [
            ./home/shell.nix
            ./home/tools.nix
            ./home/helix.nix
            ./home/development.nix
          ];
        };
      };
    } // utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            gnumake
            rnix-lsp
            nixpkgs-fmt
          ];
        };
      }
    );
}
