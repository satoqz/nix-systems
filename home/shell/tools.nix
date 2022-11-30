{pkgs, ...}: {
  home.packages = with pkgs; [
    satoqz.scripts
    cachix
    coreutils
    curl
    wget
    htop
    neofetch
    ripgrep
    jq
  ];

  programs.zsh.shellAliases = {
    top = "htop";
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
