{ pkgs, lib, inputs, user, hostname, home, isDarwin, ... }:

{
  imports =
    (if isDarwin then [ ./darwin.nix ] else [ ./linux.nix ])
    ++ lib.optional (home != [ ]) ./home-manager.nix;

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  users.users.${user}.shell = pkgs.zsh;

  networking.hostName = hostname;

  environment.pathsToLink = [ "/share/zsh" ];
}
