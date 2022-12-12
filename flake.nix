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

    nixosModules.default.imports = [
      ./modules/caretaker.nix
      ./modules/docker.nix
      ./modules/openssh.nix
      ./modules/selfhosted.nix
    ];

    homeModules.default.imports = [
      ./home/firefox.nix
      ./home/helix.nix
      ./home/tmux.nix
      ./home/tools.nix
      ./home/sioyek.nix
      ./home/vscode.nix
      ./home/zsh.nix
    ];

    nixosConfigurations = {
      moghlai = self.lib.nixosSystem {
        arch = "x86_64";
        hostname = "moghlai";
        user = "satoqz";
        config = import ./systems/moghlai.nix;
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

    packages = self.lib.forAllPkgs (pkgs: {
      local-bin = pkgs.callPackage ./packages/local-bin {};
    });

    devShells = self.lib.forAllPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [niv alejandra gnumake];
      };
    });

    formatter = self.lib.forAllPkgs (pkgs: pkgs.alejandra);
  };
}
