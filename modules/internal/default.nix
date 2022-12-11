let
  common = {
    self,
    inputs,
    lib,
    config,
    hostname,
    user,
    ...
  }: {
    options.home.imports = lib.mkOption {
      description = "shortcut for home-manager.users.${user}.imports";
      type = lib.types.listOf lib.types.path;
      default = [];
    };

    config = {
      networking.hostName = hostname;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs self;
        };
        users.${user} = {
          config.home.stateVersion = "22.11";

          # bringing homebrew casks to home-manager
          options.casks = lib.mkOption {
            description = "homebrew casks to install if the system is darwin";
            type = lib.types.listOf lib.types.string;
            default = [];
          };

          imports = config.home.imports ++ self.lib.optionalPath ../../systems/${hostname}/home.nix;
        };
      };

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
      nixpkgs.config.allowUnfree = lib.mkDefault true;
    };
  };
in {
  nixosModule = {
    inputs,
    lib,
    user,
    ...
  }: {
    imports = [
      common
      inputs.home-manager.nixosModules.home-manager
    ];

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    security.sudo.wheelNeedsPassword = lib.mkDefault false;

    time.timeZone = lib.mkDefault "Europe/Berlin";

    system.stateVersion = "22.11";
  };

  darwinModule = {
    inputs,
    lib,
    config,
    user,
    ...
  }: {
    imports = [
      common
      inputs.home-manager.darwinModules.home-manager
    ];

    services.nix-daemon.enable = true;

    homebrew = {
      enable = lib.mkDefault true;
      casks = config.home-manager.users.${user}.casks;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
      };
      taps = [
        "homebrew/core"
        "homebrew/cask"
      ];
    };

    system.stateVersion = 4;
  };
}
