inputs: let
  inherit (import ./utils.nix inputs) mkHost;
in {
  nixosConfigurations = {
    tandoori = mkHost {
      hostname = "tandoori";
      system = "aarch64-linux";
      config = {
        imports = [
          ./modules/ssh.nix
        ];

        networking.firewall.enable = false;
      };
    };

    dopiaza = mkHost {
      hostname = "dopiaza";
      system = "x86_64-linux";
      config = {user, ...}: {
        imports = [
          inputs.arion.nixosModules.arion
          ./modules/ssh.nix
          ./modules/autonomy.nix
        ];

        virtualisation.docker.enable = true;
        users.users.${user}.extraGroups = ["docker"];

        networking.domain = "trench.world";
      };
    };
  };

  darwinConfigurations = {
    korai = mkHost {
      hostname = "korai";
      system = "aarch64-darwin";
      home = {pkgs, ...}: {
        programs.hash.enable = true;
      };
    };
  };
}
