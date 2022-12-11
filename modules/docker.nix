{
  lib,
  config,
  user,
  ...
}: {
  options.virtualisation.docker = {
    networks = lib.mkOption {
      description = "bridge networks to create";
      type = lib.types.listOf lib.types.string;
      default = [];
    };
  };

  config = let
    docker = config.virtualisation.docker;
  in {
    users.users.${user}.extraGroups = lib.optional docker.enable "docker";

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
