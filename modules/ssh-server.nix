# module that sets up the openssh server with security defaults and the user's public key
{
  self,
  user,
  ...
}: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.users.${user}.openssh.authorizedKeys.keys = self.config.publicKeys;

  security.sudo.wheelNeedsPassword = false;
}
