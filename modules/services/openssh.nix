{
  self,
  lib,
  config,
  user,
  ...
}: {
  services.openssh = {
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.users.${user}.openssh.authorizedKeys.keys =
    lib.mkIf config.services.openssh.enable
    self.config.publicKeys;

  security.sudo.wheelNeedsPassword =
    lib.mkIf config.services.openssh.enable
    (lib.mkForce false);
}
