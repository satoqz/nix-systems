{config, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:satoqz/configs";
    dates = "daily";
    flags = ["-L"];
  };

  nix.gc = {
    automatic = true;
    dates = "Sun, 03:33:33";
  };

  virtualisation.docker.autoPrune = {
    enable = config.virtualisation.docker.enable;
    dates = "Sun, 03:33:33";
    flags = ["-fa"];
  };
}
