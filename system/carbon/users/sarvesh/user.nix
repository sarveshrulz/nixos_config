{ pkgs, secrets, ... }: {
  imports = [
    ../../../common/users/sarvesh/user.nix
  ];

  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        ungoogled-chromium
        onlyoffice-bin
        vscode-fhs
      ];
      file = {
        ".ssh/id_rsa".text = secrets.carbon.sarvesh.sshKeys.private;
        ".ssh/id_rsa.pub".text = secrets.carbon.sarvesh.sshKeys.public;
      };
    };

    services.mpris-proxy.enable = true;
  };

  fileSystems = {
    "/home/sarvesh/.cache/chromium" = {
      device = "tmpfs";
      fsType = "tmpfs";
      noCheck = true;
      options = [
        "noatime"
        "nodev"
        "nosuid"
        "size=128M"
      ];
    };
  };

  users.users.sarvesh.hashedPassword = secrets.carbon.sarvesh.password;
}
