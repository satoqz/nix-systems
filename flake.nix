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

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs: {
    inherit (import ./systems inputs) nixosConfigurations darwinConfigurations;

    inherit (import ./modules inputs) nixosModules darwinModules;

    hmModules = import ./home;

    lib = import ./lib inputs;

    inherit (import ./pkgs inputs) overlays packages;

    inherit (import ./shells inputs) devShells formatter;
  };
}
