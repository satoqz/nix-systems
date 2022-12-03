{ hostname, ... }:

{
  services.nix-daemon.enable = true;

  networking.localHostName = hostname;

  programs.zsh.enable = true;

  system.stateVersion = 4;
}
