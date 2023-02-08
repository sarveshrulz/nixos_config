{ pkgs, ... }: {
  home-manager.users.sarvesh.xdg.configFile."hypr/hyprland.conf".text =
    let
      swaylock = "${pkgs.swaylock-effects}/bin/swaylock --clock --timestr '%l:%M %p' --datestr '%a, %d %b %Y' --indicator --indicator-radius 100 --indicator-thickness 12 --ring-color 0a0a0a --key-hl-color b0b0b0 --effect-blur 12x12";
    in
    ''
      input {
        touchpad {
          natural_scroll = true
        }
      }
      gestures {
        workspace_swipe = true
      }
      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_autoreload = true
      }
      general {
        gaps_in = 6
        gaps_out = 12
        border_size = 0
      }
      decoration {
        rounding = 12
        blur = false
        drop_shadow = false
        dim_inactive = true
      }
      monitor = ,preffered,auto,1
      workspace = ,1
      windowrule = float,^(nm-connection-editor)$
      windowrulev2 = float,class:^(telegramdesktop)$,title:^(Media viewer)$
      bind = SUPER,RETURN,exec,footclient
      bind = SUPER,SPACE,exec,rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/apps.rasi
      bind = SUPER,Q,killactive,
      bind = SUPER,left,movefocus,l
      bind = SUPER,right,movefocus,r
      bind = SUPER,up,movefocus,u
      bind = SUPER,down,movefocus,d
      bind = SUPER_SHIFT,left,movewindow,l
      bind = SUPER_SHIFT,right,movewindow,r
      bind = SUPER_SHIFT,up,movewindow,u
      bind = SUPER_SHIFT,down,movewindow,d
      bind = SUPER,1,workspace,1
      bind = SUPER,2,workspace,2
      bind = SUPER,3,workspace,3
      bind = SUPER,4,workspace,4
      bind = SUPER,5,workspace,5
      bind = SUPER,6,workspace,6
      bind = SUPER,7,workspace,7
      bind = SUPER,8,workspace,8
      bind = SUPER,9,workspace,9
      bind = SUPER,0,workspace,10
      bind = SUPER_SHIFT,1,movetoworkspacesilent,1
      bind = SUPER_SHIFT,2,movetoworkspacesilent,2
      bind = SUPER_SHIFT,3,movetoworkspacesilent,3
      bind = SUPER_SHIFT,4,movetoworkspacesilent,4
      bind = SUPER_SHIFT,5,movetoworkspacesilent,5
      bind = SUPER_SHIFT,6,movetoworkspacesilent,6
      bind = SUPER_SHIFT,7,movetoworkspacesilent,7
      bind = SUPER_SHIFT,8,movetoworkspacesilent,8
      bind = SUPER_SHIFT,9,movetoworkspacesilent,9
      bind = SUPER_SHIFT,0,movetoworkspacesilent,10
      binde = SUPER_CTRL,right,resizeactive,10 0
      binde = SUPER_CTRL,left,resizeactive,-10 0
      binde = SUPER_CTRL,up,resizeactive,0 -10
      binde = SUPER_CTRL,down,resizeactive,0 10
      bind = SUPER_SHIFT,Q,exit,
      bind = SUPER,F,togglefloating,
      bind = SUPER,M,fullscreen,
      bind = SUPER,PRINT,exec,${pkgs.hyprwm-contrib-packages.grimblast}/bin/grimblast --notify copysave area ~/Pictures/Screenshots/$(date +'%s_screenshot.png')
      bind = SUPER,L,exec,${swaylock} --screenshots --effect-scale 0.3
      bind = ,XF86MonBrightnessUp,exec,~/.config/hypr/scripts/brightness.sh -inc 2
      bind = ,XF86MonBrightnessDown,exec,~/.config/hypr/scripts/brightness.sh -dec 2
      bind = ,XF86AudioMute,exec,~/.config/hypr/scripts/volume.sh -t
      bind = ,XF86AudioRaiseVolume,exec,~/.config/hypr/scripts/volume.sh -i 5
      bind = ,XF86AudioLowerVolume,exec,~/.config/hypr/scripts/volume.sh -d 5
      bindl = ,switch:Lid Switch,exec,${swaylock} --image ~/Pictures/Wallpapers/default --effect-scale 0.1
      bindm = SUPER,mouse:272,movewindow
      bindm = SUPER,mouse:273,resizewindow
      exec-once = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP
      exec-once = ${pkgs.gammastep}/bin/gammastep -l 19:72
      exec-once = ${pkgs.swaybg}/bin/swaybg -o \* -i ~/Pictures/Wallpapers/default -m fill
      exec-once = TERM='xterm-256color' waybar
      exec-once = foot -s
      exec-once = dunst
      exec-once = thunar --daemon
      exec-once = wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';
}
