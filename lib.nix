{
  self,
  nixpkgs,
  nixos,
  home-manager,
  ...
} @ inputs: let
  importModules = dir: let
    inherit (nixpkgs.lib) filterAttrs mapAttrs' removeSuffix;
  in
    mapAttrs' (name: _: {
      name = removeSuffix ".nix" name;
      value = import (dir + /${name});
    }) (filterAttrs (name: _: name != "default.nix") (builtins.readDir dir));

  nixosSystem = {
    arch ? "x86_64",
    stateVersion ? "22.11",
    modules ? [],
    hostName,
  }: let
    system = "${arch}-linux";

    specialArgs = {
      inherit self inputs;
    };

    defaultsModule = {
      networking.hostName = hostName;
      system.stateVersion = stateVersion;
      nix.settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["root" "@wheel"];
      };
    };
  in
    nixos.lib.nixosSystem {
      inherit system specialArgs;
      modules = modules ++ [defaultsModule];
    };

  nixosFlake = {hostname, ...} @ args: {
    inherit (self) devShells;
    nixosConfigurations.${hostname} = nixosSystem args;
  };

  homeManagerConfiguration = {
    pkgs,
    modules ? [],
    stateVersion ? "22.11",
  }: let
    home = {
      inherit stateVersion;
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
    };

    settings = {
      extra-experimental-features = "nix-command flakes";
      nix-path = [
        "nixpkgs=${nixpkgs}"
        "home-configs=${self.outPath}"
      ];
    };

    nix = {
      inherit settings;
      package = pkgs.nix;
      registry.nixpkgs.flake = nixpkgs;
    };

    defaultsModule = {
      inherit home nix;
    };

    extraSpecialArgs = {
      inherit self inputs;
    };
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules = modules ++ [defaultsModule];
    };

  homeFlake = {pkgs, ...} @ args: {
    inherit (self) devShells;
    homeConfigurations.${pkgs.system}.home =
      homeManagerConfiguration args;
  };
in {
  inherit importModules nixosSystem nixosFlake homeManagerConfiguration homeFlake;
}
