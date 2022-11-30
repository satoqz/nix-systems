{ pkgs, user, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tandoori";

  networking.firewall.enable = false;

  virtualisation.docker.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Berlin";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.openssh.enable = true;

  home-manager.users.${user} = {
    imports = builtins.map (x: ../../home/${x}.nix)
      [ "shell" "helix" "tools" ];
    home.packages = with pkgs; [
      common-utils
    ];
  };

  system.stateVersion = "22.05";
}

