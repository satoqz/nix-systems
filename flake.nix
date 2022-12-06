{
  description = "satoqz's nix environment";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    darwin-nixpkgs-unstable = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-nixpkgs-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-stable.url = "nixpkgs/nixos-22.11";

    home-nixos-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-stable";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs-unstable,
    darwin-nixpkgs-unstable,
    home-nixpkgs-unstable,
    nixos-stable,
    home-nixos-stable,
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
      home-manager ? home-nixos-stable,
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
      nixpkgs ? nixpkgs-unstable,
      darwin ? darwin-nixpkgs-unstable,
      home-manager ? home-nixpkgs-unstable,
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
      overlays.default = final: prev: {
        satoqz = {
          hash = prev.pkgs.callPackage ./pkgs/hash {};
          scripts = prev.pkgs.callPackage ./pkgs/scripts {};
        };
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
      pkgs = import nixpkgs-unstable {inherit system;};
      formatter = pkgs.alejandra;
    in {
      inherit formatter;
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          pkgs.gnumake
          pkgs.rnix-lsp
          formatter
        ];
      };
    });
}
