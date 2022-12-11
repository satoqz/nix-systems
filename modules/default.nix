{self, ...}: {
  nixosModules = {
    docker-addons = import ./docker-addons.nix;
    self-management = import ./self-management.nix;
    selfhosted-services = import ./selfhosted-services.nix;
    ssh-server = import ./ssh-server.nix;
  };

  darwinModules = {
    homebrew-casks = import ./homebrew-casks.nix;
  };
}
