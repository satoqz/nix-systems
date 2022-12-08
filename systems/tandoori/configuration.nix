{modules, ...}: {
  imports = [modules.ssh];

  networking.firewall.enable = false;
}
