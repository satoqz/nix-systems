{modules, ...}: {
  imports = [modules.homebrew];

  homebrew.casks = [
    "firefox"
    "iterm2"
    "visual-studio-code"
    "utm"
    "rectangle"
    "discord"
    "slack"
    "microsoft-teams"
    "microsoft-outlook"
    "microsoft-word"
    "microsoft-excel"
    "microsoft-powerpoint"
    "microsoft-remote-desktop"
    "pingid"
  ];
}
