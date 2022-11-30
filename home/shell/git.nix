{
  self,
  pkgs,
  ...
}: {
  home.packages = [pkgs.gitui];

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
}
