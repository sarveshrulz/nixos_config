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
    containers = {
      "immich-server" = {
        autoStart = true;
        image = "ghcr.io/immich-app/immich-server:release";
        network = [ "immich" ];
        volumes = [
          "/storage/library:/usr/src/app/upload"
          "/etc/localtime:/etc/localtime:ro"
        ];
        ports = [ "2283:2283" ];
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
    };
  };
}
