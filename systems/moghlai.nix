{modulesPath, ...}: {
  # config

  services = {
    openssh.enable = true;
    caretaker.enable = true;
    selfhosted.enable = true;
  };

  networking.domain = "trench.world";

  # hardware

  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  zramSwap.enable = true;

  boot = {
    loader.grub.device = "/dev/sda";
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };
    cleanTmpDir = true;
  };

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
