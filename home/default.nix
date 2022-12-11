{
  self,
  home-manager,
  ...
} @ inputs: {
  homeManagerModules.default = {
    imports = [
      ./shell/zsh.nix
      ./shell/tmux.nix
      ./shell/helix.nix
      ./shell/tools.nix

      ./desktop/sioyek.nix
      ./desktop/firefox.nix
      ./desktop/vscode.nix
    ];
  };

  homeConfigurations = self.lib.forAllSystems (system: {
    ${system} = home-manager.lib.homeManagerConfiguration {
      pkgs = self.lib.pkgsFor system;
      extraSpecialArgs = {
        inherit self inputs;
      };
      modules = [self.homeManagerModules.default];
    };
  });
}
