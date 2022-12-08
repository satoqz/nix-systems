{
  nixpkgs,
  darwin,
  home-manager,
  self,
  ...
} @ inputs: {
  mkCommonModule = let
    common = {
      pkgs,
      inputs,
      hostname,
      user,
      ...
    }: {
      nix = {
        settings.experimental-features = "nix-command flakes";
        registry.nixpkgs.flake = inputs.nixpkgs;
      };

      nixpkgs = {
        config.allowUnfree = true;
        overlays = [self.overlays.default];
      };

      networking.hostName = hostname;

      users.users.${user}.shell = pkgs.zsh;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          home = self.hmModules;
        };
        users.${user} = {
          imports =
            self.lib.optionalPath ../systems/${hostname}/home.nix
            ++ [self.hmModules.shell];
          home.stateVersion = "22.11";
        };
      };
    };

    linux = {user, ...}: {
      time.timeZone = "Europe/Berlin";

      users.users.${user} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
      };

      system.stateVersion = "22.11";
    };

    darwin = {...}: {
      services.nix-daemon.enable = true;

      programs.zsh.enable = true;

      environment.pathsToLink = ["/share/zsh"];

      system.stateVersion = 4;
    };
  in
    system: {lib, ...}: {
      imports =
        [common]
        ++ lib.optional (system == "linux") linux
        ++ lib.optional (system == "darwin") darwin;
    };

  optionalPath = path: nixpkgs.lib.optional (builtins.pathExists path) path;

  mkSystem = {
    system,
    hostname,
    user ? "satoqz",
  }: let
    isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
    key =
      if isDarwin
      then "darwinModules"
      else "nixosModules";
  in
    (
      if isDarwin
      then darwin.lib.darwinSystem
      else nixpkgs.lib.nixosSystem
    ) {
      inherit system;
      modules =
        [
          self.${key}.common
          home-manager.${key}.home-manager
        ]
        ++ self.lib.optionalPath ../systems/${hostname}/configuration.nix
        ++ self.lib.optionalPath ../systems/${hostname}/hardware-configuration.nix;
      specialArgs = {
        inherit inputs user hostname;
        modules = self.${key};
      };
    };
}
