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
      "visual-studio-code"
      "warp"
      "utm"
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
