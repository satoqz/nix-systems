{
  self,
  pkgs,
  ...
}: {
  programs.sioyek.package = self.lib.mkDummy pkgs "sioyek";
}
