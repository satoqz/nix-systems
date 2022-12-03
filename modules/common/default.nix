{ pkgs, lib, config, inputs, user, hostname, isDarwin, ... }:

{
  imports = if isDarwin then [ ./darwin.nix ] else [ ./linux.nix ];

  options.helixSource = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = {
    nix = {
      extraOptions = "experimental-features = nix-command flakes";
    };

    nixpkgs.config.allowUnfree = true;

    users.users.${user}.shell = pkgs.zsh;

    networking.hostName = hostname;

    environment.pathsToLink = [ "/share/zsh" ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        helixSource = config.helixSource;
        inherit inputs user hostname;
      };
      users.${user} = {
        home.stateVersion = "22.11";
        imports = [ ../../home/shell ];
      };
    };
  };
}
