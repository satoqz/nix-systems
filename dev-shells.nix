{
  self,
  pkgs,
  system,
  ...
}: let
  packages = self.packages.${system};

  wrapInScript = package:
    pkgs.writeShellScriptBin package.name "nix run .#${package.name} -- $@";

  scripts = map wrapInScript (builtins.attrValues packages);

  devTools = with pkgs; [
    alejandra
    nil
  ];
in {
  default = pkgs.mkShell {
    packages = scripts ++ devTools;
  };
}
