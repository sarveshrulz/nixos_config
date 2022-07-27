{ ... }:{
  xdg.configFile = {
    "hypr/scripts/brightness.sh" = {
      executable = true;
      source = ../files/config/hypr/scripts/brightness.sh;
    };
    "hypr/scripts/volume.sh" = {
      executable = true;
      source = ../files/config/hypr/scripts/volume.sh;
    };
    "rofi/scripts/rofi-power-menu" = {
      executable = true;
      source = ../files/config/rofi/scripts/rofi-power-menu;
    };
    "rofi/scripts/rofi-bluetooth" = {
      executable = true;
      source = ../files/config/rofi/scripts/rofi-bluetooth;
    };
    "rofi/scripts/rofi-wifi-menu" = {
      executable = true;
      source = ../files/config/rofi/scripts/rofi-wifi-menu;
    };
    "hypr/autostart" = {
      executable = true;
      source = ../files/config/hypr/autostart;
    };
    "hypr/hyprland.conf".source = ../files/config/hypr/hyprland.conf;
    "fish/functions/fish_prompt.fish".source = ../files/config/fish/functions/fish_prompt.fish;
    "rofi/apps.rasi".source = ../files/config/rofi/apps.rasi;
    "rofi/powermenu.rasi".source = ../files/config/rofi/powermenu.rasi;
    "rofi/bluetooth.rasi".source = ../files/config/rofi/bluetooth.rasi;
    "rofi/wlan.rasi".source = ../files/config/rofi/wlan.rasi;
    "dunst/icons/brightness.png".source = ../files/config/dunst/icons/brightness.png;
    "dunst/icons/muted.png".source = ../files/config/dunst/icons/muted.png;
    "dunst/icons/volume.png".source = ../files/config/dunst/icons/volume.png;
  };

  home.file = {
    ".ssh/id_rsa".source = /home/sarvesh/Storage/gdrive/SSH/id_rsa;
    ".ssh/id_rsa.pub".source = /home/sarvesh/Storage/gdrive/SSH/id_rsa.pub;
  };
}
