{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Berlin";

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  zramSwap.enable = true;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  boot.loader.grub.device = "/dev/sda";

  boot.cleanTmpDir = true;

  boot.initrd = {
    availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
    kernelModules = ["nvme"];
  };
}
