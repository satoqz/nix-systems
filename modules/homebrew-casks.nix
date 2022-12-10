# homebrew module that enables casks, as darwin desktop apps aren't widely supported by nixpkgs yet
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
    ];
  };
}
