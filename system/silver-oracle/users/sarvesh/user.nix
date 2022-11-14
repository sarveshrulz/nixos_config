{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh = {
    home.file = {
      ".ssh/id_rsa".text = secrets.silver-oracle.sarvesh.sshKeys.private;
      ".ssh/id_rsa.pub".text = secrets.silver-oracle.sarvesh.sshKeys.public;
    };
    programs.fish = {
      shellAliases = {
        edit-conf = "vim ~/.dotfiles/system/silver-oracle/configuration.nix";
        edit-user = "vim ~/.dotfiles/system/silver-oracle/users/sarvesh/user.nix";
      };
    };
  };

  users.users.sarvesh = {
    extraGroups = [ "wheel" ];
    hashedPassword = secrets.silver-oracle.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.silver-oracle.sarvesh.sshKeys.public ];
  };
}
