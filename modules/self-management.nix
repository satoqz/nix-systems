# module that enables autonomous management of a system, i.e.
# - automated system upgrades using the upstream flake
# - automated nix garbage collection
# - automated docker garbage collection
{
  lib,
  config,
  self,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = self.config.flakeUrl;
    dates = "daily";
    flags = ["-L"];
  };

  nix.gc = {
    automatic = true;
    dates = "Sun, 03:33:33";
  };

  virtualisation.docker.autoPrune = lib.mkIf config.virtualisation.docker.enable {
    enable = true;
    dates = "Sun, 03:33:33";
    flags = ["-fa"];
  };
}
