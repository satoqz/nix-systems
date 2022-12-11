{
  nixosModule = {
    imports = [
      ./docker.nix
      ./openssh.nix
      ./self-management.nix
      ./selfhosted.nix
    ];
  };

  darwinModule = {};
}
