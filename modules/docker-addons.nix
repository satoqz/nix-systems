# module that extends `virtualisation.docker` with declarative networks (yet very basic)
{
  lib,
  config,
  ...
}: {
  options.virtualisation.docker = {
    networks = lib.mkOption {
      description = "Bridge networks to create";
      type = lib.types.listOf lib.types.string;
      default = [];
    };
  };

  config = let
    docker = config.virtualisation.docker;
  in {
    systemd.services.create-docker-networks = lib.mkIf (docker.enable && docker.networks != []) {
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script = ''
        networks=(${toString docker.networks})
        for network in "''${networks[@]}"; do
          ${docker.package}/bin/docker network create $network || true
        done
      '';
    };
  };
}
