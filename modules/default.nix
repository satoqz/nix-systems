{self, ...}: {
  nixosModules = {
    autonomy = import ./autonomy.nix;
    ssh = import ./ssh.nix;
  };

  darwinModules = {};
}
