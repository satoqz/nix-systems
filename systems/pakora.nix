{
  user,
  pkgs,
  ...
}: {
  home-manager.users.${user} = {
    programs.go.enable = true;

    programs.zsh.initExtra = ''
      export PATH=$HOME/go/bin:$PATH
    '';

    home.packages = with pkgs; [
      gopls
      go-tools
      gnumake
      gcc
      nmap
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  networking = {
    useDHCP = true;
    firewall.enable = false;
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
