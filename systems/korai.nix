{
  pkgs,
  user,
  ...
}: {
  # nixpkgs.config.allowUnfree = true;

  homebrew.enable = true;

  homebrew.casks = [
    "firefox"
    "iterm2"
    "visual-studio-code"
    "sioyek"
    "rectangle"
    "discord"
    "slack"
    "microsoft-teams"
    "microsoft-remote-desktop"
    "microsoft-outlook"
    "microsoft-powerpoint"
    "microsoft-excel"
    "microsoft-word"
    "pingid"
  ];

  home-manager.users.${user}.programs = {
    firefox.enable = true;
    vscode.enable = true;
    sioyek.enable = true;
  };
}
