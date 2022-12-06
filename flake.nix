{
  description = "satoqz's nix environment";

  inputs = {
    stable.url = "nixpkgs/nixos-22.11";
    unstable.url = "nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "unstable";
    };

    home-manager.url = "github:nix-community/home-manager";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    stable,
    unstable,
    darwin,
    home-manager,
    utils,
    ...
  } @ inputs: let
    user = "satoqz";

    mkHost = {
      system,
      hostname,
      modules,
      nixpkgs,
    }: {
      inherit system;
      specialArgs = {
        inherit self system hostname user;
        inputs = inputs // {inherit nixpkgs;};
        pkgs = import nixpkgs {
          overlays = [self.overlays.default];
          inherit system;
        };
      };
      modules = let
        configPath = ./hosts/${hostname}/configuration.nix;
      in
        (nixpkgs.lib.optional (builtins.pathExists configPath) configPath) ++ modules;
    };

    mkNixosHost = {
      arch,
      hostname,
      nixpkgs ? stable,
    }:
      nixpkgs.lib.nixosSystem (mkHost {
        inherit hostname nixpkgs;
        system = "${arch}-linux";
        modules = [
          home-manager.nixosModules.home-manager
          self.nixosModules.default
        ];
      });

    mkDarwinHost = {
      arch,
      hostname,
    }:
      darwin.lib.darwinSystem (mkHost {
        inherit hostname;
        nixpkgs = unstable;
        system = "${arch}-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          self.darwinModules.default
        ];
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
          nixpkgs = unstable;
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
      formatter = pkgs.alejandra;
      devShells = import ./shells {inherit pkgs;};
    });
}
