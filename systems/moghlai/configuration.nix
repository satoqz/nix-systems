{
  services = {
    openssh.enable = true;
    self-management.enable = true;
    selfhosted.enable = true;
  };

  networking.domain = "trench.world";
}
