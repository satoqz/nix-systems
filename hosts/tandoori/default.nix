{ user, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.enable = false;

  virtualisation.docker.enable = true;

  users.users.${user}.extraGroups = [ "docker" ];

  services.openssh.enable = true;
}

