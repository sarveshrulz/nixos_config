{ ... }: {
  home-manager.users.sarvesh = {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          dynamic_padding = false;
          decorations = "full";
        };
        font = {
          normal = {
            family = "Noto Sans Mono";
            style = "Medium";
          };
          bold = {
            family = "Noto Sans Mono";
            style = "Bold";
          };
          italic = {
            family = "Noto Sans Mono";
            style = "Regular Italic";
          };
          size = 8;
        };
        colors = {
          primary = {
            background = "0x151515";
            foreground = "0xd0d0d0";
          };
          normal = {
            black = "0x151515";
            red = "0xac4142";
            green = "0x90a959";
            yellow = "0xf4bf75";
            blue = "0x6a9fb5";
            magenta = "0xaa759f";
            cyan = "0x75b5aa";
            white = "0xd0d0d0";
          };
          bright = {
            black = "0x505050";
            red = "0xac4142";
            green = "0x90a959";
            yellow = "0xf4bf75";
            blue = "0x6a9fb5";
            magenta = "0xaa759f";
            cyan = "0x75b5aa";
            white = "0xf5f5f5";
          };
        };
      };
    };
  };
}
