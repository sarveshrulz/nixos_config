{ ... }: {
  home-manager.users.sarvesh = {
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + Return" = "alacritty";
        "super + @space" = "rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/apps.rasi";
        "super + Escape" = "pkill -USR1 -x sxhkd";
        "super + shift + {q,r}" = "bspc {quit,wm -r}";
        "super + {_,shift + }q" = "bspc node -{c,k}";
        "super + g" = "bspc node -s biggest.window";
        "super + {t,shift + t,f,m}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
        "super + {_,shift + }{Left,Down,Up,Right}" = "bspc node -{f,s} {west,south,north,east}";
        "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
        "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
        "super + ctrl + {Left,Down,Up,Right}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
        "super + ctrl + shift + {Left,Down,Up,Right}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
        "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
        "XF86MonBrightness{Up,Down}" = "~/.config/sxhkd/scripts/brightness.sh {-inc 5,-dec 5}";
        "XF86Audio{RaiseVolume,LowerVolume,Mute}" = "~/.config/sxhkd/scripts/volume.sh {-i 5,-d 5,-t}";
        "super + l" = "betterlockscreen -l dimblur";
        "super + Print" = "scrot '%Y-%m-%d-%s_$wx$h_scrot.png' -e 'mv $f ~/Pictures/Screenshots'";
      };
    };
  };
}
