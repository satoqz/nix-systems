{inputs, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    dates = "Sun, 03:33:33";
  };

  nix.gc = {
    automatic = true;
    dates = "Sun, 02:22:22";
  };
}
