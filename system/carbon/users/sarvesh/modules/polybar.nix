{ ... }: {
  home-manager.users.sarvesh = {
    services.polybar = {
      enable = true;
      settings = {
        colors = {
          background = "#151515";
          background-alt = "#444";
          foreground = "#dfdfdf";
          foreground-alt = "#a0a0a0";
          primary = "#ffb52a";
          secondary = "#e60053";
          alert = "#bd2c40";
        };
        "bar/topBar" = {
          width = 1896;
          height = 38;
          radius = 12.0;
          fixed-center = true;
          offset-x = 12;
          offset-y = 12;
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
          border-size = 0;
          separator = "•";
          separator-foreground = "\${colors.foreground-alt}";
          padding-left = 4;
          padding-right = 4;
          module-margin-left = 2;
          module-margin-right = 2;
          line-size = 2;
          font-0 = "Noto Sans:style=Medium:pixelsize=13;3";
          font-1 = "FontAwesome5Free:style=Solid:size=12;3";
          font-2 = "FontAwesome5Free:style=Regular:size=12;3";
          font-3 = "FontAwesome5Brands:style=Regular:size=12;3";
          modules-left = "whoami xwindow";
          modules-center = "bspwm";
          modules-right = "wlan bluetooth pulseaudio battery date powermenu";
          wm-restack = "bspwm";
          scroll-up = "bspwm-desknext";
          scroll-down = "bspwm-deskprev";
          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
        };
        "module/whoami" = {
          type = "custom/script";
          exec = "whoami";
          interval = 3600;
          format = " <label>";
        };
        "module/bluetooth" = {
          type = "custom/script";
          exec = "~/.config/rofi/scripts/rofi-bluetooth --status";
          interval = 1;
          click-left = "~/.config/rofi/scripts/rofi-bluetooth &";
        };
        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title%";
          label-maxlen = 30;
        };
        "module/bspwm" = {
          type = "internal/bspwm";
          label-focused = "%name%";
          label-focused-foreground = "\${colors.background}";
          label-focused-background = "\${colors.foreground-alt}";
          label-focused-padding = 2;
          label-occupied = "%name%";
          label-occupied-padding = 2;
          label-urgent = "%name%!";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 2;
          label-empty = "%name%";
          label-empty-foreground = "\${colors.foreground-alt}";
          label-empty-padding = 2;
        };
        "module/wlan" = {
          type = "internal/network";
          interface = "wlan0";
          interval = 3.0;
          format-connected = "%{A1:~/.config/rofi/scripts/rofi-wifi-menu:} %{A}";
          label-disconnected = "";
          label-disconnected-foreground = "\${colors.foreground-alt}";
          format-disconnected = "%{A1:~/.config/rofi/scripts/rofi-wifi-menu:}<label-disconnected>%{A}";
        };
        "module/date" = {
          type = "internal/date";
          interval = 5;
          date = "";
          date-alt = " %Y-%m-%d";
          time = "%l:%M %p";
          time-alt = "%l:%M %p";
          format-prefix = "";
          label = "%date% %time%";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          format-volume = "<ramp-volume>";
          label-muted = "";
          label-muted-foreground = "\${colors.foreground-alt}";
          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT1";
          adapter = "ACAD";
          full-at = 99;
          format-charging = "<animation-charging> <label-charging> ";
          label-charging = "%percentage%%";
          format-discharging = "<ramp-capacity> <label-discharging>";
          label-discharging = "%percentage%%";
          label-full = "Full";
          format-full-prefix = " ";
          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";
          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-framerate = 750;
        };
        "module/powermenu" = {
          type = "custom/text";
          content = "";
          click-left = "rofi -show power-menu -modi power-menu:~/.config/rofi/scripts/rofi-power-menu -theme ~/.config/rofi/powermenu.rasi";
        };
        settings.screenchange-reload = true;
        "global/wm]" = {
          margin-top = 0;
          margin-bottom = 0;
        };
      };
      script = "polybar topBar &";
    };
  };
}
