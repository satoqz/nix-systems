{
  services.openssh.enable = true;
  services.vscode-server.enable = true;

  networking = {
    useDHCP = true;
    firewall.enable = false;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = ["virtio_pci" "xhci_pci" "usb_storage"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/265ec640-c7a2-4d8b-a3e0-79a7a16b8e51";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2966-05F4";
    fsType = "vfat";
  };
}
