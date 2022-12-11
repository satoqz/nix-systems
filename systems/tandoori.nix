{
  # config

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # hardware

  boot = {
    initrd.availableKernelModules = ["virtio_pci" "xhci_pci" "usb_storage" "usbhid"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/mnt" = {
    device = "share";
    fsType = "virtiofs";
    options = [
      "rw"
      "nofail"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  networking.useDHCP = true;
}
