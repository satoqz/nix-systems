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

  # `nixpkgs.lib.nixosSystem` wrapper
  nixosSystem = {
    arch,
    hostname,
    user ? self.config.defaultUser,
  }: let
    system = includesOrThrow systems.linux "${arch}-linux";
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self user hostname;
      };
      modules =
        [self.nixosModules.default]
        ++ optionalPath ../systems/${hostname}/configuration.nix
        ++ optionalPath ../systems/${hostname}/hardware-configuration.nix;
    };

  # `darwin.lib.darwinSystem` wrapper
  darwinSystem = {
    arch,
    hostname,
    user ? self.config.defaultUser,
  }: let
    system = includesOrThrow systems.darwin "${arch}-darwin";
  in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs self user hostname;
      };
      modules =
        [self.darwinModules.default]
        ++ optionalPath ../systems/${hostname}/configuration.nix;
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
