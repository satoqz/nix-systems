{self, ...}: {
  nixosModules = {
    common = self.lib.mkCommonModule "linux";

    autonomy = import ./autonomy.nix;
    ssh = import ./ssh.nix;
  };

  darwinModules = {
    common = self.lib.mkCommonModule "darwin";
  };
}
