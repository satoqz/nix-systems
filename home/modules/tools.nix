{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs;
    [
      coreutils
      curl
      wget
      htop
      neofetch
      ripgrep
      lsd
      gitui
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      docker-client
      docker-compose
      colima
    ];

  home.file.".docker/cli-plugins/docker-compose" = lib.mkIf pkgs.stdenv.isDarwin {
    source = "${pkgs.docker-compose}/bin/docker-compose";
  };

  programs.zsh.shellAliases = {
    top = "htop";
    ls = "lsd --icon never --almost-all";
    ll = "ls -l";
  };

  programs.git = {
    enable = true;
    userEmail = "satoqz@pm.me";
    userName = "satoqz";
    extraConfig.init.defaultBranch = "main";
    extraConfig.core.excludesfile = "~/.config/git/ignore";
  };

  home.file.".config/git/ignore".text = ''
    .DS_Store
  '';

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
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
