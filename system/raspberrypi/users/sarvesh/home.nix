{ config, pkgs, secrets, ... }: {
  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "25.05";
    packages = with pkgs; [
      podman
      podman-compose
      crun
      nixfmt-classic
      pfetch-rs
    ];
  };

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    gh.enable = true;
  };

  services.podman = {
    enable = true;
    networks."immich".autoStart = true;
    volumes."model-cache".autoStart = true;
    volumes."tailscale-data".autoStart = true;
    containers = {
      "immich-server" = {
        autoStart = true;
        image = "ghcr.io/immich-app/immich-server:release";
        network = [ "immich" ];
        volumes = [
          "/storage/library:/usr/src/app/upload"
          "/etc/localtime:/etc/localtime:ro"
        ];
        ports = [ "127.0.0.1:2283:2283" ];
        extraConfig = {
          Service.Restart = "always";
          Unit = {
            Requires = "podman-redis.service podman-database.service";
            After = "podman-redis.service podman-database.service";
          };
        };
      };
      "immich-machine-learning" = {
        autoStart = true;
        image = "ghcr.io/immich-app/immich-machine-learning:release";
        network = [ "immich" ];
        volumes = [ "model-cache:/cache" ];
        extraConfig = { Service.Restart = "always"; };
      };
      "redis" = {
        autoStart = true;
        image =
          "docker.io/valkey/valkey:8-bookworm@sha256:fec42f399876eb6faf9e008570597741c87ff7662a54185593e74b09ce83d177";
        network = [ "immich" ];
        extraConfig = { Service.Restart = "always"; };
      };
      "database" = {
        autoStart = true;
        image =
          "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0";
        network = [ "immich" ];
        environment = {
          POSTGRES_PASSWORD = secrets.raspberrypi.postgres.password;
          POSTGRES_USER = "postgres";
          POSTGRES_DB = "immich";
          DB_STORAGE_TYPE = "HDD";
          POSTGRES_INITDB_ARGS = "--data-checksums";
        };
        volumes = [ "/storage/postgres:/var/lib/postgresql/data" ];
        extraConfig = { Service.Restart = "always"; };
      };
      "tailscale" = let
        configFile = pkgs.writeText "config.json" ''
          {
            "TCP": {
              "443": {
                "HTTPS": true
              }
            },
            "Web": {
              "immich.tailc6065.ts.net:443": {
                "Handlers": {
                  "/": {
                    "Proxy": "http://127.0.0.1:2283"
                  }
                }
              }
            },
            "AllowFunnel": {
              "immich.tailc6065.ts.net:443": true
            }
          }
        '';
      in {
        autoStart = true;
        image = "tailscale/tailscale:latest";
        volumes = [
          "tailscale-data:/var/lib/tailscale"
          "${configFile}:/config/config.json:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TS_AUTHKEY = secrets.tailscale.auth.key;
          TS_AUTH_ONCE = "true";
          TS_STATE_DIR = "/var/lib/tailscale";
          TS_SERVE_CONFIG = "/config/config.json";
        };
        extraPodmanArgs = [
          "--cap-add=NET_ADMIN"
          "--hostname=immich"
          "--security-opt=label=disable"
          "--network=host"
        ];
        devices = [ "/dev/net/tun:/dev/net/tun" ];
        extraConfig = {
          Service.Restart = "always";
          Unit = {
            Requires = "podman-immich-server.service";
            After = "podman-immich-server.service";
          };
        };
      };
    };
  };
}
