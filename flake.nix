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

    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niks.url = "github:satoqz/niks";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    config = import ./config.nix;
    lib = import ./lib.nix inputs;

    nixosModules.default.imports = [
      ./nixos/caretaker.nix
      ./nixos/docker.nix
      ./nixos/openssh.nix
      ./nixos/selfhosted.nix
    ];

    darwinModules.default.imports = [
      ./darwin/homebrew.nix
    ];

    homeModules.default.imports = [
      ./home/helix.nix
      ./home/tmux.nix
      ./home/tools.nix
      ./home/zsh.nix
    ];

    nixosConfigurations = {
      moghlai = self.lib.nixosSystem {
        arch = "x86_64";
        hostname = "moghlai";
        user = "satoqz";
        config = import ./systems/moghlai.nix;
      };

      pakora = self.lib.nixosSystem {
        arch = "aarch64";
        hostname = "pakora";
        user = "satoqz";
        config = import ./systems/pakora.nix;
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

    overlays.default = import ./overlay.nix inputs;

    devShells = self.lib.forAllPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [nil alejandra gnumake];
      };
    });

    formatter = self.lib.forAllPkgs (pkgs: pkgs.alejandra);

    templates = rec {
      basic = {
        path = ./templates/basic;
        description = "nix flake init -t ${self.config.flakeUrl}#basic";
      };

      default =
        basic
        // {
          description = "nix flake init -t ${self.config.flakeUrl}";
        };

      home = {
        path = ./templates/home;
        description = "nix flake init -t ${self.config.flakeUrl}#home";
      };
    };
  };
}
