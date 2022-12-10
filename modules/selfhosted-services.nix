{
  self,
  modules,
  pkgs,
  lib,
  config,
  ...
}: {
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers = {
    watchtower = {
      image = "docker.io/containrrr/watchtower:latest";
      volumes = ["/var/run/docker.sock:/var/run/docker.sock"];
    };

    traefik = {
      image = "docker.io/traefik:latest";
      cmd = [
        "--providers.docker=true"
        "--providers.docker.exposedbydefault=false"
        "--entrypoints.web.address=:80"
        "--entrypoints.web.http.redirections.entryPoint.to=websecure"
        "--entrypoints.web.http.redirections.entryPoint.scheme=https"
        "--entrypoints.websecure.address=:443"
        "--entrypoints.websecure.http3"
        "--experimental.http3=true"
        "--certificatesresolvers.letsEncrypt.acme.email=${self.config.git.email}"
        "--certificatesresolvers.letsEncrypt.acme.storage=/srv/acme/acme.json"
        "--certificatesresolvers.letsEncrypt.acme.httpchallenge=true"
        "--certificatesresolvers.letsEncrypt.acme.httpchallenge.entrypoint=web"
        "--log.level=INFO"
      ];
      volumes = [
        "traefik-acme:/srv/acme"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      ports = [
        "443:443/tcp"
        "443:443/udp"
        "80:80/tcp"
      ];
    };

    redis = {
      image = "docker.io/redis:alpine";
      extraOptions = [
        "--tmpfs=/var/lib/redis"
      ];
      cmd = [
        "--save ''"
        "--appendonly no"
      ];
    };

    searx = {
      image = "docker.io/searxng/searxng:latest";
      dependsOn = ["redis"];
      volumes = ["${toString ./.}/searx.yml:/etc/searxng/settings.yml"];
      extraOptions = [
        "--rm" # because searxng is weird
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.searx.rule=Host(`trench.world`) || Host(`searx.coffeeco.dev`)"
        "-l=traefik.http.routers.searx.tls=true"
        "-l=traefik.http.routers.searx.tls.certresolver=letsEncrypt"
      ];
    };

    rapla = {
      image = "ghcr.io/satoqz/rapla-to-ics:latest";
      volumes = ["${toString ./.}/:/test"];
      extraOptions = [
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.rapla.rule=Host(`blade.trench.world`)"
        "-l=traefik.http.routers.rapla.tls=true"
        "-l=traefik.http.routers.rapla.tls.certresolver=letsEncrypt"
      ];
    };
  };

  # bad child :(
  # SIGTERM (systemd default) is not enough to make searx go to bed
  systemd.services.docker-searx.serviceConfig.KillSignal = "SIGKILL";

  # same goes for my own apps (need to fix upstream)
  systemd.services.docker-rapla.serviceConfig.KillSignal = "SIGKILL";
}
