{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.tools.enable = lib.mkEnableOption "additional shell tools";

  config = {
    programs.tools.enable = lib.mkDefault true;

    home.packages = with pkgs;
      lib.mkIf config.programs.tools.enable [
        local-bin
        cachix
        coreutils
        curl
        wget
        htop
        neofetch
        ripgrep
        jq
      ];

    programs.zsh.shellAliases = lib.mkIf config.programs.tools.enable {
      top = "htop";
    };

    programs.lsd = {
      enable = config.programs.tools.enable;
      enableAliases = true;
    };

    programs.fzf = {
      enable = config.programs.tools.enable;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = config.programs.tools.enable;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
