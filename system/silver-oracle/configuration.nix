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

  security.sudo.wheelNeedsPassword = false;

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
