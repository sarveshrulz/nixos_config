{ pkgs, secrets, ... }: {
  imports = [
    ../../../common/users/sarvesh/user.nix
    modules/imports.nix
  ];

  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        firefox-wayland
        onlyoffice-bin
        rofi-wayland
        xfce.thunar
        wl-clipboard
        tdesktop
        nodejs
        freerdp
        vscode-fhs
        sshpass
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
            exec Hyprland
          fi
        '';
        shellAliases.carbon-oracle = "ssh sarvesh@140.238.167.175";
      };
      foot = {
        enable = true;
        settings = {
          main = {
            font = "SF Mono:weight=500:size=7";
            pad = "12x12";
          };
          colors = {
            background = "0a0a0a";
            foreground = "b0b0b0";
            regular0 = "0a0a0a";
            regular1 = "ac4142";
            regular2 = "90a959";
            regular3 = "f4bf75";
            regular4 = "6a9fb5";
            regular5 = "aa759f";
            regular6 = "75b5aa";
            regular7 = "b0b0b0";
            bright0 = "4a4a4a";
            bright1 = "ac4142";
            bright2 = "90a959";
            bright3 = "f4bf75";
            bright4 = "6a9fb5";
            bright5 = "aa759f";
            bright6 = "75b5aa";
            bright7 = "f5f5f5";
          };
        };
      };
    };

    services = {
      mpris-proxy.enable = true;
      dunst = {
        enable = true;
        settings = {
          global = {
            width = "(0, 360)";
            height = 136;
            offset = "12x12";
            frame_width = 0;
            padding = 8;
            font = "SF Pro Text 10";
            max_icon_size = 14;
            corner_radius = 12;
            separator_height = 1;
            separator_color = "#4a4a4a";
          };
          urgency_low = {
            background = "#0a0a0a";
            foreground = "#b0b0b0";
            timeout = 3;
          };
          urgency_normal = {
            background = "#0a0a0a";
            foreground = "#b0b0b0";
            timeout = 5;
          };
          urgency_critical = {
            background = "#a54242";
            foreground = "#0a0a0a";
            timeout = 7;
          };
        };
      };
    };

    xdg.configFile = {
      "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
      "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
      "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
    };
  };

  fileSystems."/home/sarvesh/.cache/mozilla" = {
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
