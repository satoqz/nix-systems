{
  description = "satoqz's nix environment";

  inputs = {
    unstable.url = "nixpkgs/nixpkgs-unstable";

    nix-darwin-unstable = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "unstable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    nixos-stable.url = "nixpkgs/nixos-22.11";

    home-manager-nixos-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    utils.url = "github:numtide/flake-utils";

    helix.url = "github:helix-editor/helix";
  };

  outputs = {
    self,
    unstable,
    nix-darwin-unstable,
    home-manager-unstable,
    nixos-stable,
    home-manager-nixos-stable,
    utils,
    ...
  } @ inputs: let
    defaultUser = "satoqz";

    mkHost = {
      system,
      hostname,
      user,
      nixpkgs,
      modules,
      darwin ? null,
    }: {
      inherit system;
      specialArgs = {
        pkgs = import nixpkgs {
          overlays = [self.overlays.default];
          inherit system;
        };
        inputs = inputs // {inherit nixpkgs darwin;};
        inherit self system hostname user;
      };
      modules = let
        configPath = ./hosts/${hostname}/configuration.nix;
      in
        (nixpkgs.lib.optional (builtins.pathExists configPath) configPath) ++ modules;
    };

    mkNixosHost = {
      arch,
      hostname,
      user ? defaultUser,
      nixpkgs ? nixos-stable,
      home-manager ? home-manager-nixos-stable,
      modules ? [],
    }:
      nixpkgs.lib.nixosSystem (mkHost {
        system = "${arch}-linux";
        modules =
          [
            home-manager.nixosModules.home-manager
            self.nixosModules.default
          ]
          ++ modules;
        inherit hostname user nixpkgs;
      });

    mkDarwinHost = {
      arch,
      hostname,
      user ? defaultUser,
      nixpkgs ? unstable,
      darwin ? nix-darwin-unstable,
      home-manager ? home-manager-unstable,
      modules ? [],
    }:
      darwin.lib.darwinSystem (mkHost {
        system = "${arch}-darwin";
        modules =
          [
            home-manager.darwinModules.home-manager
            self.darwinModules.default
          ]
          ++ modules;
        inherit hostname user nixpkgs darwin;
      });
  in
    {
      overlays.default = final: prev:
        with prev.pkgs; {
          hash = callPackage ./pkgs/hash {};
          darwin-utils = callPackage ./pkgs/darwin-utils {};
          common-utils = callPackage ./pkgs/common-utils {};
        };

      nixosModules.default = import ./module/nixos.nix;

      darwinModules.default = import ./module/darwin.nix;

      nixosConfigurations = {
        tandoori = mkNixosHost {
          hostname = "tandoori";
          arch = "aarch64";
        };

        dopiaza = mkNixosHost {
          hostname = "dopiaza";
          arch = "x86_64";
        };
      };

      darwinConfigurations = {
        korai = mkDarwinHost {
          hostname = "korai";
          arch = "aarch64";
        };
      };
    }
    // utils.lib.eachDefaultSystem (system: let
      pkgs = import unstable {inherit system;};
    in {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          gnumake
          rnix-lsp
          nixpkgs-fmt
        ];
      };
      formatter = pkgs.alejandra;
    });
}
