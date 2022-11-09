{ pkgs, secrets, ... }: {
  imports = [
    ../common.nix
    ./users/sarvesh/user.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "silver-oracle";

  services.openssh.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDksSd2571cu+MZ069N88t6itzDxhpwGg5D4884sAnNVhirDvC/OwPKK4Fq/GCGRZlK0l3PZNkl5yxmHSIA4IJJYod2hYCPCw68HJMc1QWn+yKXqatRdr8u5apIHeoQU0Pzytfp/oEm8A+erm9jCZ9kLrWi5Wptqq8VT1qoCR8nzGlDCMjH4NK9rTdNP2qqDSBgOcZyTPxH7G6WlFYt/oXoQRYdPQ7i7njW5K0rdrq0vlzlPyKvRsgQD4OsYNsSf8fpnlGSDPbrGb6ANiM/Uz9kZCNgl9SYsihzYSDvg/9u9j4ilInJ1UveD8F52TCSnbrM5JPIA7Hp6jbeTef/7l4rNZx7WGoxBOQwbF5AW0N+LH/tUvm3+R/CMfOETgUbjwEKU84D8k8ABWrnLB1p4F/QbJt8xwaLC9bd+Uw0KIN92QmUtKsMMrx6htDRJ3CVsfPIjckwn7nTVUkAY9UIjZ/JlL2N2VLpgQ3mgSfk5xu6E9SKscxwiG6VIebcl/lHjtc= sarvesh@silver" ];
    hashedPassword = secrets.silver-oracle.root.password;
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation = {
    oci-containers = {
      backend = "podman";
      containers = {
        #####
    };
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
    };
  };
}
