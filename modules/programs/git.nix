{
  self,
  pkgs,
  lib,
  config,
  ...
}: {
  programs.git = {
    enable = lib.mkDefault true;
    userEmail = self.config.git.email;
    userName = self.config.git.user;
    extraConfig.init.defaultBranch = "main";
  };

  programs.gh = {
    enable = config.programs.git.enable;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };

  home.packages = lib.mkIf config.programs.git.enable [pkgs.gitui];
}
