{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    loader.grub.device = "/dev/vda";
    cleanTmpDir = true;
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
      kernelModules = [ "nvme" ];
    };
  };

  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };

  zramSwap.enable = true;
}
