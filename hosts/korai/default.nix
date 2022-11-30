{ pkgs, user, ... }:

{
  services.nix-daemon.enable = true;

  nix.extraOptions = "build-users-group = nixbld";

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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

  environment.extraInit = "eval $(/opt/homebrew/bin/brew shellenv)";

  system.stateVersion = 4;
}
