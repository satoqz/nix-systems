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
  pkgsFor = system: import nixpkgs {inherit system;};

  # iterate through a given list of `systems` and generate an attribute set with
  # the system names as its keys and the value set to the result of `f <pkgs for system>`
  forEachPkgs = systems: f: forEachSystem systems (system: f (pkgsFor system));

  # `forEachPkgs` for all default systems
  forAllPkgs = forEachPkgs systems.default;

  # return `[path]` if `path` exists, else `[]`
  optionalPath = path: nixpkgs.lib.optional (builtins.pathExists path) path;

  # `nixpkgs.lib.nixosSystem` wrapper:
  # - load `systems/{hostname}/configuration.nix` and `systems/{hostname}/hardware-configuration.nix`
  #   if they exist
  # - load default system modules (common & nixos) from `config.nix`
  # - load default home-manager modules (common & nixos) from `config.nix`
  # - load internal common defaults module
  # - load home-manager module
  # - optionally, disable all default module loading via `defaults = false`
  # - set hostname
  nixosSystem = {
    arch,
    hostname,
    user ? self.config.systemDefaults.user,
    defaults ? true,
  }: let
    system = includesOrThrow systems.linux "${arch}-linux";
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self user hostname;
        modules = self.nixosModules;
      };
      modules =
        optionalPath ../systems/${hostname}/configuration.nix
        ++ optionalPath ../systems/${hostname}/hardware-configuration.nix
        ++ nixpkgs.lib.optionals defaults [
          _commonModule
          self.config.systemDefaults.commonModule
          self.config.systemDefaults.nixosModule
          home-manager.nixosModules.home-manager
          {
            home-manager.users.${user}.imports = [
              self.config.homeDefaults.commonModule
              self.config.homeDefaults.nixosModule
            ];
          }
        ]
        ++ [
          ({lib, ...}: {
            networking.hostName = hostname;
          })
        ];
    };

  # `darwin.lib.darwinSystem` wrapper:
  # - load `systems/{hostname}/configuration.nix` if it exists
  # - load default system modules (common & darwin) from `config.nix`
  # - load default home-manager modules (common & darwin) from `config.nix`
  # - load internal common defaults module
  # - load home-manager module
  # - optionally, disable all default module loading via `defaults = false`
  # - set hostname & enable nix daemon
  darwinSystem = {
    arch,
    hostname,
    user ? self.config.systemDefaults.user,
    defaults ? true,
  }: let
    system = includesOrThrow systems.darwin "${arch}-darwin";
  in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs self user hostname;
        modules = self.darwinModules;
      };
      modules =
        optionalPath ../systems/${hostname}/configuration.nix
        ++ nixpkgs.lib.optionals defaults [
          _commonModule
          self.config.systemDefaults.commonModule
          self.config.systemDefaults.darwinModule
          home-manager.darwinModules.home-manager
          {
            home-manager.users.${user}.imports = [
              self.config.homeDefaults.commonModule
              self.config.homeDefaults.darwinModule
            ];
          }
        ]
        ++ [
          ({lib, ...}: {
            services.nix-daemon.enable = true;
            networking = {
              hostName = hostname;
              localHostName = hostname;
            };
          })
        ];
    };

  # system module that sets internal defaults that shouldn't be subject to `config.nix`
  # - configure nix
  # - add our own overlay to every system
  # - import systems/${hostname}/home.nix into the home-manager configuration if it exists
  # - pass arguments to home-manager modules
  _commonModule = {
    pkgs,
    lib,
    user,
    hostname,
    ...
  }: {
    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["root" user];
        extra-substituters = map (it: it.url) self.config.substituters;
        extra-trusted-public-keys = map (it: it.publicKey) self.config.substituters;
      };
      registry.nixpkgs.flake = inputs.nixpkgs;
    };

    nixpkgs.overlays = [self.overlays.default];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${user}.imports = optionalPath ../systems/${hostname}/home.nix;
      extraSpecialArgs = {
        inherit inputs self;
        home = self.hmModules;
      };
    };
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
