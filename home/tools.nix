{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    coreutils
    curl
    wget
    htop
    neofetch
    ripgrep
    gitui
    jq

    common-utils
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    darwin-utils
    hash
  ];

  programs.zsh.shellAliases = {
    "top" = "htop";
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "satoqz@pm.me";
    userName = "satoqz";
    extraConfig.init.defaultBranch = "main";
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
