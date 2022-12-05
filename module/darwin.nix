{
  lib,
  config,
  hostname,
  ...
}: {
  imports = [./common.nix];

  services.nix-daemon.enable = true;

  networking.localHostName = hostname;

  programs.zsh.enable = true;

  environment.extraInit =
    lib.mkIf config.homebrew.enable
    "eval $(/opt/homebrew/bin/brew shellenv)";

  system.stateVersion = 4;
}
