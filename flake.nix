{
  description = "satoqz's nixos configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    {
      nixosModules = let
        inherit (nixpkgs.lib) mapAttrs' removeSuffix;
      in
        mapAttrs' (name: _: {
          name = removeSuffix ".nix" name;
          value = import ./modules/${name};
        }) (builtins.readDir ./modules);

      lib.nixosSystem = {
        arch ? "x86_64",
        stateVersion ? "22.11",
        modules ? [],
        hostName,
      }: let
        inherit (nixpkgs.lib) singleton optional;
        optionalPath = path: optional (builtins.pathExists path) path;
      in
        nixpkgs.lib.nixosSystem {
          system = "${arch}-linux";
          specialArgs = {
            inherit self inputs;
          };
          modules =
            modules
            ++ optionalPath ./systems/${hostName}.nix
            ++ singleton ({pkgs, ...}: {
              nix.settings.experimental-features = "nix-command flakes";
              networking.hostName = hostName;
              system.stateVersion = stateVersion;
            });
        };

      lib.nixosFlake = {hostname, ...} @ args: {
        inherit (self) devShells;
        nixosConfigurations.${hostname} = self.lib.nixosSystem args;
      };

      nixosConfigurations = let
        inherit (self.lib) nixosSystem;
      in {
        vps = nixosSystem {
          hostName = "vps";
          modules = with self.nixosModules; [
            satoqz
            caretaker
            selfhosted
          ];
        };

        utm-vm = nixosSystem {
          hostName = "utm-vm";
          modules = with self.nixosModules; [
            satoqz
            inputs.vscode-server.nixosModules.default
          ];
        };

        # requires impure build
        ci = let
          inherit (nixpkgs.lib) optional singleton;
          module = builtins.getEnv "CI_MODULE";
          fakeDevice = "/ruby"; # does not exist
        in
          nixosSystem {
            hostName = "ci";
            modules =
              optional (module != "") self.nixosModules.${module}
              ++ singleton {
                boot.loader.grub.device = fakeDevice;
                fileSystems."/" = {
                  device = fakeDevice;
                  fsType = "ext4";
                };
              };
          };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShell {
        packages = [
          formatter
          pkgs.nil
        ];
      };
    });
}
