{ pkgs, ... }: {
  home-manager.users.sarvesh.programs.waybar = {
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
        format = "";
        on-click = "~/.config/rofi/scripts/rofi-wifi-menu";
        tooltip = false;
      };
      "pulseaudio" = {
        format = "{icon}";
        format-muted = "<span color=\"#4a4a4a\"></span>";
        format-icons = [ "" "" "" ];
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
        background: transparent;
      }
      #workspaces, #workspaces button, #battery, #bluetooth, #network, #clock, #clock.time, #pulseaudio, #custom-bluetooth, #custom-power {
        font-family: "SF Pro Text", "FontAwesome6Free";
        font-weight: bold;
        color: #b0b0b0;
        background-color: #0a0a0a;
        border-radius: 0;
        transition: none;
        padding: 0 8px;
      }
      #custom-power, #clock.time, #workspaces button.active {
        background-color: #b0b0b0;
        color: #0a0a0a;
        border-radius: 0 12px 12px 0;
      }
      #custom-power {
        background-color: #a54242;
      }
      #clock, #network {
        border-radius: 12px 0 0 12px;
      }
      #workspaces, #workspaces button {
        padding: 0 4px 0 4px;
        border-radius: 12px;
      }
      #workspaces button.active {
        border-radius: 50%;
        padding: 0 4px;
        margin: 4px 0 4px 0;
      }
      #network.disconnected {
        color: #4a4a4a;
      }
    '';
  };
}
