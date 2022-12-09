{
  lib,
  config,
  self,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = self.config.flakeUrl;
    dates = "Sun, 01:11:11";
    flags = ["-L"];
  };

  nix.gc = {
    automatic = true;
    dates = "Sun, 02:22:22";
  };

  virtualisation.docker.autoPrune = lib.mkIf config.virtualisation.docker.enable {
    enable = true;
    dates = "Sun, 03:33:33";
    flags = ["-fa"];
  };
}
