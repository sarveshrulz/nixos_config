{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh.home.file = {
    ".ssh/id_rsa".text = secrets.silver-oracle.sarvesh.sshKeys.private;
    ".ssh/id_rsa.pub".text = secrets.silver-oracle.sarvesh.sshKeys.public;
  };

  users.users.sarvesh = {
    hashedPassword = secrets.silver-oracle.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.silver-oracle.sarvesh.sshKeys.public ];
  };
}
