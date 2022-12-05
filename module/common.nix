{
  pkgs,
  lib,
  inputs,
  user,
  hostname,
  ...
}: {
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostname;

  users.users.${user}.shell = pkgs.zsh;

  environment.pathsToLink = ["/share/zsh"];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.${user} = {
      home.stateVersion = "22.11";
      imports = let
        homePath = ../hosts/${hostname}/home.nix;
      in
        lib.optional (builtins.pathExists homePath) homePath ++ [../home];
    };
  };
}
