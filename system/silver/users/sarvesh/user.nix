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
          update-system = "pushd ~/.dotfiles && git add . && sudo nixos-rebuild switch --flake .#; popd";
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

    services.dunst = {
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

    xdg.configFile = {
      "hypr/scripts/brightness.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          msgId="69"
          xbacklight -fps 60 "$@"
          curr="$(xbacklight -get)"
          dunstify -a "changeBrightness" -i ~/.config/dunst/icons/brightness.png -u low -r "$msgId" "Brightness: $curr%"
        '';
      };
      "hypr/scripts/volume.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          msgId="69"
          pamixer $@ > /dev/null
          if [ $(pamixer --get-mute) = true ] && [ ! $@ = '-t' ]; then
               pamixer -t
          fi
          volume=$(pamixer --get-volume)
          mute=$(pamixer --get-mute)
          if [ $volume = 0 ] || [ $mute = true ]; then
              dunstify -a "changeVolume" -i ~/.config/dunst/icons/muted.png -u low -r "$msgId" "Volume: muted" 
          else
              dunstify -a "changeVolume" -i ~/.config/dunst/icons/volume.png -u low -r "$msgId" "Volume: $volume%"
          fi
        '';
      };
      "hypr/autostart" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP &
          dunst &
          wl-paste -t text --watch clipman store &
          gammastep -l 19:72 &
          ~/.nix-profile/libexec/polkit-gnome-authentication-agent-1 &
          foot -s &
          thunar --daemon &
          waybar &
          swaybg -o \* -i ~/Pictures/Wallpapers/default -m fill
        '';
      };
      "hypr/hyprland.conf".text = ''
        monitor=,1920x1080@60,0x0,1
        input {
            follow_mouse=1
            touchpad {
              natural_scroll=1
            }
        }
        gestures {
            workspace_swipe=1
        }
        misc {
            disable_hyprland_logo=1
            disable_splash_rendering=1
            disable_autoreload=1
        }
        general {
            sensitivity=1.0
            gaps_in=6
            gaps_out=12
            border_size=0
            damage_tracking=full
        }
        decoration {
            rounding=12
            drop_shadow=0
            blur=0
            multisample_edges=0
        }
        animations {
            enabled=1
            animation=windows,1,7,default
            animation=fade,1,10,default
            animation=workspaces,1,6,default
        }
        workspace=,1
        windowrule=float,^(Rofi)$
        windowrule=float,^(Dunst)$
        bind=SUPER,RETURN,exec,footclient
        bind=SUPER,SPACE,exec,rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/apps.rasi
        bind=SUPER,Q,killactive,
        bind=SUPER,left,movefocus,l
        bind=SUPER,right,movefocus,r
        bind=SUPER,up,movefocus,u
        bind=SUPER,down,movefocus,d
        bind=SUPER_SHIFT,left,movewindow,l
        bind=SUPER_SHIFT,right,movewindow,r
        bind=SUPER_SHIFT,up,movewindow,u
        bind=SUPER_SHIFT,down,movewindow,d
        bind=SUPER,1,workspace,1
        bind=SUPER,2,workspace,2
        bind=SUPER,3,workspace,3
        bind=SUPER,4,workspace,4
        bind=SUPER,5,workspace,5
        bind=SUPER,6,workspace,6
        bind=SUPER,7,workspace,7
        bind=SUPER,8,workspace,8
        bind=SUPER,9,workspace,9
        bind=SUPER,0,workspace,10
        bind=SUPER_SHIFT,1,movetoworkspacesilent,1
        bind=SUPER_SHIFT,2,movetoworkspacesilent,2
        bind=SUPER_SHIFT,3,movetoworkspacesilent,3
        bind=SUPER_SHIFT,4,movetoworkspacesilent,4
        bind=SUPER_SHIFT,5,movetoworkspacesilent,5
        bind=SUPER_SHIFT,6,movetoworkspacesilent,6
        bind=SUPER_SHIFT,7,movetoworkspacesilent,7
        bind=SUPER_SHIFT,8,movetoworkspacesilent,8
        bind=SUPER_SHIFT,9,movetoworkspacesilent,9
        bind=SUPER_SHIFT,0,movetoworkspacesilent,10
        bind=SUPER_SHIFT,Q,exit,
        bind=SUPER,F,togglefloating,
        bind=SUPER,M,fullscreen,
        bind=SUPER,PRINT,exec,grim ~/Pictures/Screenshots/$(date +'%s_grim.png') && dunstify "Screenshot saved!"
        bind=,XF86MonBrightnessUp,exec,~/.config/hypr/scripts/brightness.sh -inc 2
        bind=,XF86MonBrightnessDown,exec,~/.config/hypr/scripts/brightness.sh -dec 2
        bind=,XF86AudioMute,exec,~/.config/hypr/scripts/volume.sh -t
        bind=,XF86AudioRaiseVolume,exec,~/.config/hypr/scripts/volume.sh -i 5
        bind=,XF86AudioLowerVolume,exec,~/.config/hypr/scripts/volume.sh -d 5
        exec-once=/home/sarvesh/.config/hypr/autostart
      '';
      "rofi/apps.rasi".text = ''
        configuration {
        	font: "Noto Sans Semi-bold 11";
        	me-select-entry: "MouseSecondary";
        	me-accept-entry: "MousePrimary";
          drun-display-format: "{name}";
        }
        window {
          width: 224px;
        }
        * {
          background: #0a0a0a;
          foreground: #b0b0b0;
        }
        entry {
          padding: 12px 12px 0px 12px;
        }
        prompt, textbox-prompt-colon, case-indicator {
          enabled: false;
        }
        mainbox, entry, listview, element {
          background-color: @background;
          text-color: @foreground;
        }
        listview {
          lines: 4;
          padding: 12px;
          spacing: 4px;
          cycle: false;
        }
        element-text selected {
          background-color: @foreground;
          text-color: @background;
          border-radius: 12px;
        }
        element-text {
          padding: 6px 12px;
          background-color: @background;
          text-color: @foreground;
        }
      '';
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
      "weston/background.jpg".source = ./files/config/weston/background.jpg;
      "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
      "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
      "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
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

  };

  services.getty = {
    loginOptions = "-p -- sarvesh";
    extraArgs = [ "--noclear" "--skip-login" ];
    greetingLine = "Welcome to silver! please enter password for sarvesh to login...";
  };

  security.pam.enableEcryptfs = true;

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
