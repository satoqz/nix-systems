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
      extraOptions = [
        "--network=internal"
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
        "--network=internal"
        "--tmpfs=/var/lib/redis"
      ];
      cmd = [
        "--save ''"
        "--appendonly no"
      ];
    };

    searx = let
      settings = {
        use_default_settings = true;
        redis.url = "redis://redis:6379/0";
        server = {
          instance_name = "${config.networking.domain}";
          base_url = "https://${config.networking.domain}";
          limiter = true;
          image_proxy = true;
          method = "POST";
          http_protocol_version = "1.1";
        };
        ui = {
          static_use_hash = true;
          infinite_scroll = true;
          center_alignment = true;
          results_on_new_tab = true;
          query_in_title = true;
        };
        search = {
          autocomplete = "duckduckgo";
          autocomplete_min = 4;
          safe_search = 2;
        };
        enabled_plugins = [
          "Hash plugin"
          "Search on category select"
          "Tracker URL remover"
          "Vim-like hotkeys"
          "Hostname replace"
        ];
        hostname_replace = {
          "(.*\\.)?reddit.com$" = "libreddit.de";
          "(.*\\.)?twitter.com$" = "nitter.net";
        };
      };
    in {
      image = "docker.io/searxng/searxng:latest";
      volumes = [
        "${builtins.toFile "settings.yml" (builtins.toJSON settings)}:/etc/searxng/settings.yml"
      ];
      extraOptions = [
        "--network=internal"
        "--entrypoint=/bin/sh"
        "--rm" # because searxng is weird
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.searx.rule=Host(`${config.networking.domain}`) || Host(`searx.coffeeco.dev`)"
        "-l=traefik.http.routers.searx.tls=true"
        "-l=traefik.http.routers.searx.tls.certresolver=letsEncrypt"
      ];
      cmd = [
        "-c"
        # no need for a persistent secret
        "export SEARXNG_SECRET=$(openssl rand -base64 128) && exec /sbin/tini -- /usr/local/searxng/dockerfiles/docker-entrypoint.sh"
      ];
      dependsOn = ["redis"];
    };

    rapla = {
      image = "ghcr.io/satoqz/rapla-to-ics:latest";
      extraOptions = [
        "--network=internal"
        "-l=traefik.enable=true"
        "-l=traefik.http.routers.rapla.rule=Host(`blade.${config.networking.domain}`)"
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
