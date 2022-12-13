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
  };

  environment.extraInit =
    lib.mkIf config.homebrew.enable
    "eval $(/opt/homebrew/bin/brew shellenv)";
}
