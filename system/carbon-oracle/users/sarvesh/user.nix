{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh.home = {
    packages = with pkgs; [
      ungoogled-chromium
      vscode
    ];
    file = {
      ".ssh/id_rsa".text = secrets.carbon-oracle.sarvesh.sshKeys.private;
      ".ssh/id_rsa.pub".text = secrets.carbon-oracle.sarvesh.sshKeys.public;
    };
    gtk =
      let
        gtkconf = {
          gtk-application-prefer-dark-theme = 1;
          gtk-cursor-theme-name = "capitaine-cursors-white";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "rgb";
        };
      in
      {
        enable = true;
        font = {
          name = "SF Pro Text";
        };
        theme = {
          package = pkgs.materia-theme;
          name = "Materia-dark-compact";
        };
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-blue-dark";
        };
        gtk4.extraConfig = gtkconf;
        gtk3.extraConfig = gtkconf;
        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme=1
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintfull"
          gtk-xft-rgba="rgb"
          gtk-cursor-theme-name="capitaine-cursors-white"
        '';
      };
  };

  users.users.sarvesh = {
    hashedPassword = secrets.carbon-oracle.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.carbon-oracle.sarvesh.sshKeys.public ];
  };
}
