{pkgs, ...}: {
  home.packages = with pkgs; [
    docker
    docker-client
    colima
    satoqz.hash
  ];

  home.file.".docker/cli-plugins/docker-compose".source = "${pkgs.docker-compose}/bin/docker-compose";

  programs.zsh.profileExtra = "eval $(/opt/homebrew/bin/brew shellenv)";
}
