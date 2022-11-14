{ pkgs, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./users/sarvesh/user.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "silver-oracle";

  services.openssh.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [ secrets.silver-oracle.sarvesh.sshKeys.public ];
    hashedPassword = secrets.silver-oracle.root.password;
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
