{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelModules = [];
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["virtio_pci" "xhci_pci" "usb_storage" "usbhid"];
      kernelModules = [];
    };
    loader = {
      systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/22212dbb-25cd-448d-bc3d-c5dfff3e24db";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AC68-695D";
    fsType = "vfat";
  };

  fileSystems."/mac" = {
    device = "share";
    fsType = "virtiofs";
    options = [
      "rw"
      "nofail"
    ];
  };

  swapDevices = [];

  networking.useDHCP = true;
}
