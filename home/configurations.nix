{
  self,
  nixpkgs,
  pkgs,
  ...
}: let
  modules = self.homeModules;

  toHome = configuration:
    self.lib.homeManagerConfiguration (configuration
      // {
        inherit pkgs;
      });

  mkConfigurations = builtins.mapAttrs (_: x: toHome x);
in
  mkConfigurations {
    all.modules = builtins.attrValues modules;

    ci.modules = let
      ciModule = builtins.getEnv "CI_MODULE";
    in
      nixpkgs.lib.optional (ciModule != "") modules.${ciModule};
  }
