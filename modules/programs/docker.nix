{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.docker.enable = lib.mkEnableOption "docker tools (darwin)";

  config = lib.mkIf (pkgs.stdenv.isDarwin && config.programs.docker.enable) {
    home.packages = with pkgs;
      config.programs.docker.enable [
        docker-client
        docker-compose
        colima
      ];

    home.file.".docker/cli-plugins/docker-compose" = {
      source = "${pkgs.docker-compose}/bin/docker-compose";
    };
  };
}
