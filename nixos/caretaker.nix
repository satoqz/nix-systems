{
  lib,
  config,
  self,
  ...
}: {
  options.services.caretaker.enable =
    lib.mkEnableOption
    "automated system upgrades, nix & docker garbage collection";

  config = {
    system.autoUpgrade = {
      enable = config.services.caretaker.enable;
      flake = self.config.flakeUrl;
      dates = "daily";
      flags = ["-L"];
    };

    nix.gc = {
      automatic = config.services.caretaker.enable;
      dates = "Sun, 03:33:33";
    };

    virtualisation.docker.autoPrune = {
      enable = config.services.caretaker.enable;
      dates = "Sun, 03:33:33";
      flags = ["-fa"];
    };
  };
}
