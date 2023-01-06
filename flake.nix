{
  description = "satoqz's nix environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    vscode-server.url = "github:msteen/nixos-vscode-server";

    niks.url = "github:satoqz/niks";
  };

  outputs = {self, ...} @ inputs: {
    lib = import ./lib.nix inputs;

    nixosModules.default.imports = [
      ./nixos/caretaker.nix
      ./nixos/docker.nix
      ./nixos/openssh.nix
      ./nixos/selfhosted.nix
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

    devShells = self.lib.forAllPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [nil alejandra gnumake];
      };
    });

    formatter = self.lib.forAllPkgs (pkgs: pkgs.alejandra);
  };

  nixConfig = {
    extra-substituters = ["https://systems.cachix.org"];
    extra-trusted-public-keys = ["systems.cachix.org-1:w+BPDlm25/PkSE0uN9uV6u12PNmSsBuR/HW6R/djZIc="];
  };
}
