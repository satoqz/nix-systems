{
  self,
  nixpkgs,
  darwin,
  home-manager,
  ...
} @ inputs: rec {
  # write `attrs1 // attrs2 // attrs3` as a (much prettier) list expression
  mergeAttrs = list: _mergeAttrs {} list;
  _mergeAttrs = set: list:
    if list == []
    then set
    else _mergeAttrs (set // builtins.head list) (builtins.tail list);

  # test whether a list includes a value
  includes = list: item: nixpkgs.lib.any (x: x == item) list;

  # test if a `list` includes `item`, if yes return `item` else throw an error
  includesOrThrow = list: item:
    if includes list item
    then item
    else throw "Expected list [${toString list}] to include ${item}";

  # constants with system doubles
  systems = rec {
    linux = ["x86_64-linux" "aarch64-linux"];
    darwin = ["x86_64-darwin" "aarch64-darwin"];
    default = darwin ++ linux;
  };

  # iterate through a given list of `systems` and generate an attribute set with
  # the system names as its keys and the value set to the result of `f <system>`
  forEachSystem = systems: f:
    builtins.listToAttrs (map (name: {
        inherit name;
        value = f name;
      })
      systems);

  # `forEachSystem` for all default systems
  forAllSystems = forEachSystem systems.default;

  # get the `pkgs` for a system double
  pkgsFor = system:
    import nixpkgs {
      inherit system;
    };

  # iterate through a given list of `systems` and generate an attribute set with
  # the system names as its keys and the value set to the result of `f <pkgs for system>`
  forEachPkgs = systems: f: forEachSystem systems (system: f (pkgsFor system));

  # `forEachPkgs` for all default systems
  forAllPkgs = forEachPkgs systems.default;

  # return `[path]` if `path` exists, else `[]`
  optionalPath = path: nixpkgs.lib.optional (builtins.pathExists path) path;

  # generate `config.nix`
  mkNixConfig = pkgs: {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-substituters = ["https://systems.cachix.org"];
    };
  };

  # generate `config.home-manager`
  mkHomeManagerConfig = user: {
    useGlobalPkgs = nixpkgs.lib.mkDefault true;
    useUserPackages = nixpkgs.lib.mkDefault true;
    extraSpecialArgs = {
      inherit inputs self;
    };
    users.${user} = {
      home.stateVersion = "22.11";
      imports = [self.homeModules.default];
    };
  };

  # `nixpkgs.lib.nixosSystem` wrapper
  nixosSystem = {
    arch,
    hostname,
    user,
    config ? {},
  }: let
    system = includesOrThrow systems.linux "${arch}-linux";
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit self inputs user;
      };
      modules = [
        config
        self.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        ({pkgs, ...}: {
          networking.hostName = hostname;

          nix = mkNixConfig pkgs;
          home-manager = mkHomeManagerConfig user;

          time.timeZone = nixpkgs.lib.mkDefault "Europe/Berlin";

          users.users.${user} = {
            isNormalUser = true;
            extraGroups = ["wheel"];
            shell = pkgs.zsh;
          };

          security.sudo.wheelNeedsPassword = nixpkgs.lib.mkDefault false;

          system.stateVersion = "22.11";
        })
      ];
    };

  # `darwin.lib.darwinSystem` wrapper
  darwinSystem = {
    arch,
    hostname,
    user,
    config ? {},
  }: let
    system = includesOrThrow systems.darwin "${arch}-darwin";
  in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit self inputs user;
      };
      modules = [
        config
        self.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        ({pkgs, ...}: {
          networking.hostName = hostname;

          nix = mkNixConfig pkgs;
          home-manager = mkHomeManagerConfig user;

          users.users.${user}.shell = pkgs.zsh;

          # darwin requires global zsh for things to link up properly
          programs.zsh.enable = true;
          environment.pathsToLink = ["/share/zsh"];

          services.nix-daemon.enable = true;

          system.stateVersion = 4;
        })
      ];
    };

  # `home-manager.lib.homeManagerConfiguration` wrapper
  homeManagerConfiguration = {
    user,
    system,
    config ? {},
    ...
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
      };

      extraSpecialArgs = {
        inherit inputs self;
      };

      modules = [
        config
        self.homeModules.default
        ({
          pkgs,
          lib,
          ...
        }: {
          home = {
            stateVersion = "22.11";
            username = user;
            homeDirectory =
              if user == "root"
              then "/root"
              else if pkgs.stdenv.isDarwin
              then "/Users/${user}"
              else "/home/${user}";
          };
        })
      ];
    };

  # utility variable that summarizes all system outputs under a uniform path (useful for automation)
  top = mergeAttrs [
    (nixpkgs.lib.genAttrs
      (builtins.attrNames self.nixosConfigurations)
      (attr: self.nixosConfigurations.${attr}.config.system.build.toplevel))
    (nixpkgs.lib.genAttrs
      (builtins.attrNames self.darwinConfigurations)
      (attr: self.darwinConfigurations.${attr}.system))
  ];
}
