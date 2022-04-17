{ config, pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      gaps.inner = 12;
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      keybindings = {
        "Mod4+Return" = "exec foot";
        "Mod4+space" = "exec rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/apps.rasi";
        "Mod4+q" = "kill";
        "Mod4+Left" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";
        "Mod4+Shift+Left" = "move left";
        "Mod4+Shift+Down" = "move down";
        "Mod4+Shift+Up" = "move up";
        "Mod4+Shift+Right" = "move right";
        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";
        "Mod4+5" = "workspace number 5";
        "Mod4+6" = "workspace number 6";
        "Mod4+7" = "workspace number 7";
        "Mod4+8" = "workspace number 8";
        "Mod4+9" = "workspace number 9";
        "Mod4+0" = "workspace number 10";
        "Mod4+Shift+1" = "move container to workspace number 1";
        "Mod4+Shift+2" = "move container to workspace number 2";
        "Mod4+Shift+3" = "move container to workspace number 3";
        "Mod4+Shift+4" = "move container to workspace number 4";
        "Mod4+Shift+5" = "move container to workspace number 5";
        "Mod4+Shift+6" = "move container to workspace number 6";
        "Mod4+Shift+7" = "move container to workspace number 7";
        "Mod4+Shift+8" = "move container to workspace number 8";
        "Mod4+Shift+9" = "move container to workspace number 9";
        "Mod4+Shift+0" = "move container to workspace number 10";
        "XF86MonBrightnessUp" = "exec ~/.config/sway/scripts/brightness.sh -inc 2";
        "XF86MonBrightnessDown" = "exec ~/.config/sway/scripts/brightness.sh -dec 2";
        "XF86AudioRaiseVolume" = "exec ~/.config/sway/scripts/volume.sh -i 5";
        "XF86AudioLowerVolume" = "exec ~/.config/sway/scripts/volume.sh -d 5";
        "XF86AudioMute" = "exec ~/.config/sway/scripts/volume.sh -t";
        "Mod4+f" = "floating toggle";
        "Mod4+m" = "fullscreen toggle";
        "Mod4+h" = "split h";
        "Mod4+v" = "split v";
        "Mod4+r" = "mode resize";
        "Mod4+Shift+r" = "restart";
        "Mod4+Shift+q" = "exit";
        "Mod4+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save screen ~/Pictures/Screenshots/\"screenshot-\$(date +%Y-%m-%d-%s).png\"";
      };
      focus.followMouse = "always";
      modes = {
        resize = {
          Left = "resize shrink width";
          Right = "resize grow width";
          Down = "resize shrink height";
          Up = "resize grow height";
          Return = "mode default";
          Escape = "mode default";
        };
      };
      floating = {
        modifier = "Mod4";
        border = 0;
      };
      defaultWorkspace = "workspace number 1";
      output."*".background = "/home/sarvesh/Pictures/Wallpapers/default fill";
      window.border = 0;
      startup = [
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
      ];
    };
  };
}
