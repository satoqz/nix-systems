inputs: let
  inherit (inputs) nixpkgs darwin home-manager;
in {
  # utility wrapper around nixpkgs.lib.nixosSystem and darwin.lib.darwinSystem
  # - enables sane defaults for both systems
  # - imports the system's hardware configuration if any,
  # - sets up home-manager and loads home.nix
  # - registers pkgs/overlay.nix
  mkHost = {
    system,
    hostname,
    config ? {},
    home ? {},
    user ? "satoqz",
  }: let
    isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
  in
    (
      if isDarwin
      then darwin.lib.darwinSystem
      else nixpkgs.lib.nixosSystem
    ) {
      inherit system;
      specialArgs = {
        inherit inputs hostname user;
      };
      modules = let
        hardware = ./hardware/${hostname}.nix;
      in
        (nixpkgs.lib.optional (builtins.pathExists hardware) hardware)
        ++ [
          home-manager
          .${
            if isDarwin
            then "darwinModules"
            else "nixosModules"
          }
          .home-manager
          # common options for all systems
          ({pkgs, ...}: {
            nix = {
              settings.experimental-features = "nix-command flakes";
              registry.nixpkgs.flake = inputs.nixpkgs;
            };

            nixpkgs = {
              config.allowUnfree = true;
              overlays = [(import ./pkgs/overlay.nix inputs)];
            };

            networking.hostName = hostname;

            users.users.${user}.shell = pkgs.zsh;

            environment.pathsToLink = ["/share/zsh"];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.${user} = {
                imports = [./home.nix home];
                home.stateVersion = "22.11";
              };
            };
          })
        ]
        # common options for darwin systems
        ++ nixpkgs.lib.optional isDarwin {
          system.stateVersion = 4;
          services.nix-daemon.enable = true;
          networking.localHostName = hostname;
          programs.zsh.enable = true;
        }
        ## common options for linux systems
        ++ nixpkgs.lib.optional (! isDarwin) {
          system.stateVersion = "22.11";
          time.timeZone = "Europe/Berlin";
          users.users.${user} = {
            isNormalUser = true;
            extraGroups = ["wheel"];
          };
        };
    };
}
