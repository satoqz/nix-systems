{
  self,
  pkgs,
  ...
}: {
  programs.vscode.package = self.lib.mkDummy pkgs "vscode";
}
