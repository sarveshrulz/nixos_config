{ pkgs, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./users/sarvesh/user.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    hostName = "carbon-oracle";
    firewall.allowedTCPPorts = [ 3389 ];
  };

  services = {
    xserver.desktopManager.xfce.enable = true;
    xrdp = {
      enable = true;
      defaultWindowManager = "startxfce4";
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [ secrets.carbon-oracle.sarvesh.sshKeys.public ];
    hashedPassword = secrets.carbon-oracle.root.password;
  };
}
