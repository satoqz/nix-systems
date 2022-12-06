{
  imports = [
    ./hardware-configuration.nix
  ];

  services.openssh.lockdown = true;

  virtualisation.docker.enable = true;

  networking.domain = "trench.world";

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.autoUpgrade.enable = true;
}
