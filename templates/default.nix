{...}: {
  nixos = {
    description = "NixOS flake quickstarter";
    path = ./nixos;
  };

  home = {
    description = "home-manager flake quickstarter";
    path = ./home;
  };
}
