{
  pkgs,
  user,
  ...
}: {
  homebrew.enable = true;

  homebrew.casks = [
    "eloston-chromium"
    "iterm2"
    "utm"
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
}
