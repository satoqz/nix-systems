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

  outputs = inputs: {
    inherit (import ./systems inputs) nixosConfigurations darwinConfigurations;

    inherit (import ./modules) nixosModules darwinModules;

    inherit (import ./shells inputs) devShells formatter;

    inherit (import ./pkgs inputs) overlays packages;

    config = import ./config.nix;

    lib = import ./lib inputs;
  };
}
