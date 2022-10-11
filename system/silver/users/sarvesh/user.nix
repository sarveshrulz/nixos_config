{ pkgs, ... }: {
  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        librewolf-wayland
        tdesktop
        bc
        bpytop
        capitaine-cursors
        nixpkgs-fmt
        swaybg
        gammastep
        bluetuith
        onlyoffice-bin
        clipman
        wl-clipboard
        mate.eom
        polkit_gnome
        pamixer
        rofi
        xfce.thunar
        grim
      ];
      stateVersion = "22.11";
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
        };
      };
      fish = {
        enable = true;
        loginShellInit = ''
          if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
            echo -e "Select session:\n[H] Hyprland\n[W] Waydroid\n[N] none\n"
            read -P "[H/w/n]: " c
            test -n $c; or set c "H"
            if test $c = "H" || test $c = "h"
              exec Hyprland
            else if test $c = "W" || test $c = "w"
              exec ~/.config/weston/waydroid-session
            end
          end
        '';
        shellInit = ''
          set fish_greeting
          ${pkgs.pfetch}/bin/pfetch
        '';
        shellAliases = {
          editconf = "codium ~/.dotfiles";
          update-flake = "pushd ~/.dotfiles && nix flake update; popd";
          update-system = "pushd ~/.dotfiles && git add . && sudo nixos-rebuild switch --flake .#silver; popd";
        };
      };
      git = {
        enable = true;
        userName = "sarveshrulz";
        userEmail = "sarveshkardekar@gmail.com";
      };
      vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
        ];
      };
      foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:weight=500:slant=italic:size=7";
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
      waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
        settings = [{
          position = "top";
          margin = "12 12 0 12";
          modules-left = [ "wlr/workspaces" ];
          modules-center = [ "clock" "clock#time" ];
          modules-right = [ "network" "pulseaudio" "custom/bluetooth" "battery" "custom/power" ];
          "clock" = {
            format = "{:%a, %d %b %Y}";
            interval = 3600;
          };
          "clock#time" = {
            format = "{:%I:%M %p}";
            interval = 60;
          };
          "network" = {
            format = " ";
            on-click = "~/.config/rofi/scripts/rofi-wifi-menu";
            tooltip = false;
          };
          "pulseaudio" = {
            format = "{icon}";
            format-muted = "<span color=\"#4a4a4a\"> </span>";
            format-icons = [ " " " " " " ];
            on-click = "pamixer -t";
            tooltip = false;
          };
          "battery" = {
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-icons = [ "" "" "" "" "" ];
            tooltip = false;
          };
          "custom/power" = {
            format = "";
            on-click = "rofi -show power-menu -modi power-menu:~/.config/rofi/scripts/rofi-power-menu -theme ~/.config/rofi/powermenu.rasi";
            tooltip = false;
          };
          "custom/bluetooth" = {
            exec = "~/.config/rofi/scripts/rofi-bluetooth --status";
            interval = 1;
            on-click = "~/.config/rofi/scripts/rofi-bluetooth";
            tooltip = false;
          };
        }];
        style = ''
          #waybar {
            font-family: "NotoSans", "FontAwesome6Free";
            font-weight: bolder;
            background: transparent;
            color: #b0b0b0;
          }
          #workspaces {
            border-radius: 12px;
            padding: 4px;
          }
          #workspaces button {
            color: #b0b0b0;
            border-radius: inherit;
            font-weight: inherit;
            transition: none;
            padding: 0 4px;
          }
          #workspaces, #network, #pulseaudio, #battery, #clock, #custom-bluetooth {
            background: #0a0a0a;
          }
          #custom-power, #network, #pulseaudio, #battery, #clock, #clock.time, custom-bluetooth {
            padding: 0 8px;
          }
          #network, #clock {
            border-radius: 12px 0 0 12px;
          }
          #custom-power, #clock.time {
            border-radius: 0 12px 12px 0;
          }
          #clock.time {
            padding-left: 4px;
          }
          #workspaces button.active, #clock.time {
            background: #b0b0b0;
            color: #0a0a0a;
          }
          #network.disconnected {
            color: #4a4a4a;
          }
          #custom-power {
            background: #a54242;
            color: #0a0a0a;
          }
        '';
      };
    };

    services = {
      dunst = {
        enable = true;
        settings = {
          global = {
            width = "(0, 360)";
            height = 136;
            offset = "12x12";
            frame_width = 0;
            padding = 8;
            font = "Noto Sans 10";
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
      "hypr/scripts/brightness.sh" = {
        executable = true;
        source = ./files/config/hypr/scripts/brightness.sh;
      };
      "hypr/scripts/volume.sh" = {
        executable = true;
        source = ./files/config/hypr/scripts/volume.sh;
      };
      "hypr/autostart" = {
        executable = true;
        source = ./files/config/hypr/autostart;
      };
      "rofi/scripts/rofi-power-menu" = {
        executable = true;
        source = ./files/config/rofi/scripts/rofi-power-menu;
      };
      "rofi/scripts/rofi-bluetooth" = {
        executable = true;
        source = ./files/config/rofi/scripts/rofi-bluetooth;
      };
      "rofi/scripts/rofi-wifi-menu" = {
        executable = true;
        source = ./files/config/rofi/scripts/rofi-wifi-menu;
      };
      "hypr/hyprland.conf".source = ./files/config/hypr/hyprland.conf;
      "rofi/apps.rasi".source = ./files/config/rofi/apps.rasi;
      "rofi/powermenu.rasi".source = ./files/config/rofi/powermenu.rasi;
      "rofi/bluetooth.rasi".source = ./files/config/rofi/bluetooth.rasi;
      "rofi/wlan.rasi".source = ./files/config/rofi/wlan.rasi;
      "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
      "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
      "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
      "weston/background.jpg".source = ./files/config/weston/background.jpg;
      "weston.ini".text = ''
        [libinput]
        enable-tap=true
        natural-scroll=true
        [shell]
        panel-position=none
        background-image=/home/sarvesh/.config/weston/background.jpg
      '';
      "weston/waydroid-session" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          (${pkgs.westonLite}/bin/weston; waydroid session stop) &
          WAYLAND_DISPLAY="wayland-1" waydroid show-full-ui
        '';
      };
    };

    gtk =
      let
        gtkconf = {
          gtk-application-prefer-dark-theme = 1;
          gtk-cursor-theme-name = "capitaine-cursors-white";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
        };
      in
      {
        enable = true;
        font = {
          name = "Noto Sans";
          size = 11;
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
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
          gtk-cursor-theme-name="capitaine-cursors-white"
        '';
      };

    dconf.settings."org/gnome/desktop/interface".cursor-theme = "capitaine-cursors-white";
  };

  fileSystems."/home/sarvesh/.cache/librewolf" = {
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
    greetingLine = "Welcome to silver! please enter password for sarvesh to login...";
  };

  users.users = {
    sarvesh = {
      description = "Sarvesh Kardekar";
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
      shell = pkgs.fish;
      hashedPassword = "$6$Zwt2/p7axZKbTrAS$TLnZdKjq8D712/Ps1bs2QU2VKVESksTc7cg4t6QDbXKTaA7i5NMJNjcRnwKg6vFVk5qVPO//p8PFniEVfRo8R/";
    };
  };
}
