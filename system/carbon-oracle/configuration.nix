{ pkgs, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./users/sarvesh/user.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "carbon-oracle";

  services.openssh.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [ secrets.carbon-oracle.sarvesh.sshKeys.public ];
    hashedPassword = secrets.carbon-oracle.root.password;
  };

  virtualisation = {
    oci-containers = {
      backend = "podman";
      containers = {
        #####
      };
    };
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
    };
  };
}
