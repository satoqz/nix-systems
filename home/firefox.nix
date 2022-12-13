{
  self,
  pkgs,
  ...
}: {
  programs.firefox.package = self.lib.mkDummy pkgs "firefox";
}
