{ pkgs, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./users/sarvesh/user.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "carbon-oracle";

  users.users.root = {
    openssh.authorizedKeys.keys = [ secrets.carbon.sarvesh.sshKeys.public ];
    hashedPassword = secrets.carbon.root.password;
  };
}
