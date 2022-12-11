{
  description = "satoqz's nix environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    config = import ./config.nix;
    lib = import ./lib inputs;

    nixosModules.default = {
      imports = [
        ./modules/caretaker.nix
        ./modules/docker.nix
        ./modules/openssh.nix
        ./modules/selfhosted.nix
      ];
    };

    darwinModules.default = {};

    homeManagerModules.default = {
      imports = [
        ./home/shell/zsh.nix
        ./home/shell/tmux.nix
        ./home/shell/helix.nix
        ./home/shell/tools.nix
        ./home/desktop/firefox.nix
        ./home/desktop/sioyek.nix
        ./home/desktop/vscode.nix
      ];
    };

    nixosConfigurations = {
      moghlai = self.lib.nixosSystem {
        arch = "x86_64";
        hostname = "moghlai";
        user = "satoqz";
        config = import ./systems/moghlai.nix;
      };

      tandoori = self.lib.nixosSystem {
        arch = "aarch64";
        hostname = "tandoori";
        user = "satoqz";
        config = import ./systems/tandoori.nix;
      };
    };

    darwinConfigurations = {
      korai = self.lib.darwinSystem {
        arch = "aarch64";
        hostname = "korai";
        user = "satoqz";
        config = import ./systems/korai.nix;
      };
    };

    homeManagerConfigurations = self.lib.forEachSystem (system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = self.lib.pkgsFor system;
        imports = [self.homeManagerModules.default];
        extraSpecialArgs = {
          inherit self inputs;
        };
      });

    packages = self.lib.forAllPkgs (pkgs: {
      local-bin = pkgs.callPackage ./packages/local-bin {
        inherit (self) config;
      };
    });

    devShells = self.lib.forAllPkgs (pkgs: import ./shells pkgs);

    formatter = self.lib.forAllPkgs (pkgs: pkgs.alejandra);
  };
}
