{
  self,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      self.packages.${pkgs.system}.local-bin
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
    htop = "htop -C";
    top = "htop -C";

    ga = "git add";
    gc = "git commit";
    gpl = "git pull";
    gps = "git push";
    gl = "git log";
    gr = "git reset";
    gd = "git diff";
    gds = "git diff --staged";
  };

  programs.git = {
    enable = true;
    userEmail = self.config.git.email;
    userName = self.config.git.user;
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
