{
  self,
  lib,
  ...
}: let
  ciModule = builtins.getEnv "CI_MODULE";
  fakeDevice = "/ruby"; # does not exist
in {
  imports = lib.optional (ciModule != "") self.nixosModules.${ciModule};

  boot.loader.grub.device = fakeDevice;
  fileSystems."/" = {
    device = fakeDevice;
    fsType = "ext4";
  };
}
