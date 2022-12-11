let
  common = {
    imports = [./zsh.nix];
    home.imports = [
      ./docker.nix
      ./firefox.nix
      ./helix.nix
      ./git.nix
      ./sioyek.nix
      ./starship.nix
      ./tmux.nix
      ./tools.nix
      ./vscode.nix
    ];
  };
in {
  nixosModule = {
    imports = [common];
  };

  darwinModule = {
    imports = [common];
  };
}
