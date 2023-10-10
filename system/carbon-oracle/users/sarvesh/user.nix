{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh.home.file = {
    ".ssh/id_rsa".text = secrets.carbon.sarvesh.sshKeys.private;
    ".ssh/id_rsa.pub".text = secrets.carbon.sarvesh.sshKeys.public;
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 443 ];
  };

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        nextcloud-aio-mastercontainer = {
          autoStart = true;
	  image = "nextcloud/all-in-one:latest";
	  ports = [ "80:80" "8080:8080" "8443:8443" ];
	  volumes = [ "nextcloud_aio_mastercontainer:/mnt/docker-aio-config" "//var/run/docker.sock:/var/run/docker.sock:ro" ];
	};
      };
    };
  };

  users.users.sarvesh = {
    hashedPassword = secrets.carbon.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.carbon.sarvesh.sshKeys.public ];
  };
}
