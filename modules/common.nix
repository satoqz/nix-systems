{ pkgs, inputs, user, hostname, home, ... }:

{
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
    extraSpecialArgs = { inherit inputs user hostname; };
    users.${user} = {
      home.stateVersion = "23.05";
      imports = home;
    };
  };
}
