{
  lib,
  config,
  inputs,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    dates = "Sun, 01:11:11";
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L"
    ];
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
