{ pkgs, ... }: {
  home-manager.users.sarvesh.xdg.configFile = {
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
      text =
        let
          pamixer = "${pkgs.pamixer}/bin/pamixer";
        in
        ''
          #!/usr/bin/env bash
          msgId="69"
          ${pamixer} $@ > /dev/null
          if [ $(${pamixer} --get-mute) = true ] && [ ! $@ = '-t' ]; then
               ${pamixer} -t
          fi
          volume=$(${pamixer} --get-volume)
          mute=$(${pamixer} --get-mute)
          if [ $volume = 0 ] || [ $mute = true ]; then
              dunstify -a "changeVolume" -i ~/.config/dunst/icons/muted.png -u low -r "$msgId" "Volume: muted" 
          else
              dunstify -a "changeVolume" -i ~/.config/dunst/icons/volume.png -u low -r "$msgId" "Volume: $volume%"
          fi
        '';
    };
  };
}
