{ pkgs, secrets, ... }: {
  imports = [
    ../../../common/users/sarvesh/user.nix
    modules/imports.nix
  ];

  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        ungoogled-chromium
        onlyoffice-bin
        rofi
        tdesktop
        nodejs
        freerdp
        vscode-fhs
        sshpass
	xorg.xinit
      ];
      file = {
        ".ssh/id_rsa".text = secrets.carbon.sarvesh.sshKeys.private;
        ".ssh/id_rsa.pub".text = secrets.carbon.sarvesh.sshKeys.public;
      };
    };

    programs = {
      mpv = {
        enable = true;
        config = {
          profile = "gpu-hq";
          scale = "ewa_lanczossharp";
          cscale = "ewa_lanczossharp";
          video-sync = "display-resample";
          interpolation = true;
          tscale = "oversample";
          ao = "pipewire";
        };
      };
      zsh = {
        initExtra = ''
          if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
            # exec startx
          fi
        '';
        shellAliases.carbon-oracle = "ssh sarvesh@140.238.167.175";
      };
    };

    services.mpris-proxy.enable = true;

    xdg.configFile = {
      "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
      "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
      "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
    };
  };

  # fileSystems."/home/sarvesh/.cache/mozilla" = {
  #   device = "tmpfs";
  #   fsType = "tmpfs";
  #   noCheck = true;
  #   options = [
  #     "noatime"
  #     "nodev"
  #     "nosuid"
  #     "size=128M"
  #   ];
  # };

  services.getty = {
    loginOptions = "-p -- sarvesh";
    extraArgs = [ "--noclear" "--skip-login" ];
    greetingLine = "Welcome to carbon! please enter password for sarvesh to login...";
  };

  users.users.sarvesh = {
    hashedPassword = secrets.carbon.sarvesh.password;
    extraGroups = [ "video" ];
  };
}
