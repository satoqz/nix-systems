# config.nix - constants and default system and home modules
rec {
  # git information
  git = {
    user = "satoqz";
    email = "satoqz@pm.me";
  };

  # url used any time the flake refers to itself (e.g. for upgrades)
  flakeUrl = "github:${git.user}/nix-systems";

  # substituters installed in the systems
  substituters = [
    {
      url = "https://systems.cachix.org";
      publicKey = "systems.cachix.org-1:w+BPDlm25/PkSE0uN9uV6u12PNmSsBuR/HW6R/djZIc=";
    }
  ];

  # default user name used in `lib.{nixosSystem|darwinSystem}`
  systemDefaults.user = git.user;

  # defaults for all systems
  systemDefaults.commonModule = {
    pkgs,
    lib,
    user,
    ...
  }: {
    users.users.${user}.shell = pkgs.zsh;
    nixpkgs.config.allowUnfree = true;
  };

  # defaults for all NixOS systems
  systemDefaults.nixosModule = {
    lib,
    user,
    ...
  }: {
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    security.sudo.wheelNeedsPassword = false;

    time.timeZone = "Europe/Berlin";

    system.stateVersion = "22.11";
  };

  # defaults for all Darwin systems
  systemDefaults.darwinModule = {
    programs.zsh.enable = true;
    environment.pathsToLink = ["/share/zsh"];

    system.stateVersion = 4;
  };

  # defaults for all homes
  homeDefaults.commonModule = {home, ...}: {
    imports = [home.shell];
    home.stateVersion = "22.11";
  };

  # defaults for all NixOS homes
  homeDefaults.nixosModule = {};

  # defaults for all Darwin homes
  homeDefaults.darwinModule = {};
}
