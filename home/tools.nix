{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs;
    [
      inputs.niks.packages.${pkgs.system}.default
      local-bin
      cachix
      coreutils
      curl
      wget
      htop
      neofetch
      gitui
      ripgrep
      jq
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
  };

  programs.git = {
    enable = true;
    userEmail = self.config.git.email;
    userName = self.config.git.user;
    extraConfig.init.defaultBranch = "main";
    extraConfig.core.excludesfile = "${config.home.homeDirectory}/.config/git/ignore";
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
