{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh.home.file = {
    ".ssh/id_rsa".text = secrets.carbon.sarvesh.sshKeys.private;
    ".ssh/id_rsa.pub".text = secrets.carbon.sarvesh.sshKeys.public;
  };

  users.users.sarvesh = {
    hashedPassword = secrets.carbon.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.carbon.sarvesh.sshKeys.public ];
  };
}
