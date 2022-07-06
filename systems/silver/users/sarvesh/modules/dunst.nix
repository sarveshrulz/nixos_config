{ ... }: {
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
}
