{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    settings = [{
      position = "top";
      margin = "12 12 0 12";
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "clock" "clock#time" ];
      modules-right = [ "network" "pulseaudio" "custom/bluetooth" "battery" "custom/power" ];
      modules = {
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "X";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };
        };
        "clock" = {
          format = "{:%a, %d %b %Y}";
          interval = 3600;
        };
        "clock#time" = {
          format = "{:%l:%M %p}";
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
      };
    }];
    style = ''
      #waybar {
        font-family: "NotoSans", "FontAwesome5Free";
        font-weight: bolder;
        background: transparent;
        color: #b0b0b0;
      }
      #workspaces {
        margin-right: 4px;
        padding: 0 4px;
      }
      #workspaces, #workspaces button:hover, #network, #pulseaudio, #battery, #clock, #mode, #custom-bluetooth {
        background: #0a0a0a;
      }
      #workspaces button, #custom-power, #network, #pulseaudio, #battery, #clock, #mode, #clock.time, custom-bluetooth {
        padding: 0 8px;
      }
      #network, #clock {
        border-radius: 4px 0 0 4px;
      }
      #custom-power, #clock.time {
        border-radius: 0 4px 4px 0;
      }
      #clock.time {
        padding-left: 4px;
      }
      #workspaces, #mode {
        border-radius: 4px;
      }
      #workspaces button {
        margin: 4px 0;
        color: #b0b0b0;
      }
      #workspaces button.focused, #workspaces button.focused:hover, #clock.time {
        background: #b0b0b0;
        color: #0a0a0a;
      }
      #mode {
        background: #b0b0b0;
        color: #0a0a0a;
      }
      #workspaces button:hover, #workspaces button.focused:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        transition: none;
        border: 0;
        padding: 0 9px;
      }
      #network.disconnected, #workspaces button.persistent  {
        color: #4a4a4a;
      }
      #custom-power {
        background: #a54242;
        color: #0a0a0a;
      }
    '';
  };
}
