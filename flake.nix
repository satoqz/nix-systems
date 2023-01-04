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

    vscode-server.url = "github:msteen/nixos-vscode-server";

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

    devShells = self.lib.forAllPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [nil alejandra gnumake];
      };
    });

    formatter = self.lib.forAllPkgs (pkgs: pkgs.alejandra);
  };

  nixConfig = {
    extra-substitutors = ["https://systems.cachix.org"];
    extra-trusted-public-keys = ["systems.cachix.org-1:w+BPDlm25/PkSE0uN9uV6u12PNmSsBuR/HW6R/djZIc="];
  };
}
