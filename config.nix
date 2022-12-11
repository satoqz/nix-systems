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

  # public keys that are used by `modules/ssh-server`
  publicKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6eAwwmeujQ8phKn57VbgxUAHvE8Z1XraqCYlzr9IAp8ea+Sx+efhxLk1XveHJispz0zkP2SgNCFDsQhuDDpJXejhiIpsnr6PlNzrRNTggQzurESkM/OTS+aaeNLd4vncEDxzPf4zWxHgt3ZN4UXlOJHzXgp4UWE+sWXAOdwI1L5ZaOWb6R8XuipmNlBJW7QxBhWPJylxsQW5XsMb/aweW5JHVxqGaIhA8Dui3onB9RvqvNyZXIZx29A9CbAbZYZwfZ3o43RrvGNMYeVyMT+LP8TgQY7X7tHk2aplDugabO46T1J5+z9Hq8GFjQ8dddk/JbPqEQhcH0718C7AH94ieL3s5KIZm1Thp7oVlJYXEMxldF6BfOXzjeE05wR9E63lnKqLicijbJLxr5Tvdo0R2y/P0ImVzXZY3MgLRe1z3qQb1sVSwg3O1q5s6BJ2fi1cCXtV6noWzy9cHivWxOR3aPiwIQBN5xWA3eeSImjAlmZTKOomC3SIFfzZYb+r5sPE="
  ];
}
