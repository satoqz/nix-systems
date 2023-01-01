{
  lib,
  config,
  ...
}: {
  homebrew = {
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };

    taps = [
      "homebrew/core"
      "homebrew/cask"
    ];

    caskArgs.no_quarantine = true;
  };

  environment.extraInit =
    lib.mkIf config.homebrew.enable
    "eval $(/opt/homebrew/bin/brew shellenv)";
}
