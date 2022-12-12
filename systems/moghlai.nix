{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  services = {
    openssh.enable = true;
    caretaker.enable = true;
    selfhosted.enable = true;
  };

  networking.domain = "trench.world";

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
