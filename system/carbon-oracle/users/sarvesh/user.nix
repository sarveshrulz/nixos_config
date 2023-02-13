{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh.home = {
    packages = [ pkgs.vscode ];
    file = {
      ".ssh/id_rsa".text = secrets.carbon-oracle.sarvesh.sshKeys.private;
      ".ssh/id_rsa.pub".text = secrets.carbon-oracle.sarvesh.sshKeys.public;
    };
  };

  users.users.sarvesh = {
    hashedPassword = secrets.carbon-oracle.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.carbon-oracle.sarvesh.sshKeys.public ];
  };
}
