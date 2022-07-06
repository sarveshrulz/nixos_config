{ ... }: {
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  programs.waybar = {
    enable = true;
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
}
