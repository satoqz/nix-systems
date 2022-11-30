{pkgs, ...}: {
  home.packages = with pkgs; [
    docker-client
    docker-compose
    colima
  ];

  home.file.".docker/cli-plugins/docker-compose" = {
    source = "${pkgs.docker-compose}/bin/docker-compose";
  };
}
