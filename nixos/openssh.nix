{
  self,
  lib,
  user,
  ...
}: {
  services.openssh = {
    passwordAuthentication = lib.mkDefault false;
    permitRootLogin = lib.mkDefault "no";
  };

  users.users.${user}.openssh.authorizedKeys.keys =
    self.config.publicKeys;
}
