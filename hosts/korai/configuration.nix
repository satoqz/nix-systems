{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "iterm2"
      "utm"
      "visual-studio-code"
      "rectangle"
      "discord"
      "slack"
      "microsoft-teams"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "microsoft-excel"
      "microsoft-word"
      "microsoft-remote-desktop"
      "pingid"
    ];
  };
}
