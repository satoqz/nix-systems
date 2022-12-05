{
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.enable = false;

  services.openssh.enable = true;
}
