{ ... }: {
  home-manager.users.sarvesh.xdg.configFile =
    let
      rofi-theme = ''
        configuration {
        	font: "SF Pro Text Bold 11";
        	me-select-entry: "MouseSecondary";
        	me-accept-entry: "MousePrimary";
          hover-select: true;
          location: 3;
        }
        window {
          x-offset: -12px;
          y-offset: 12px;
          border-radius: 12px;
        }
        * {
          background: #0a0a0a;
          foreground: #b0b0b0;
        }
        entry {
          padding: 12px 12px 0px 12px;
        }
        prompt, textbox-prompt-colon, case-indicator {
          enabled: false;
        }
        mainbox, entry, listview, element {
          background-color: @background;
          text-color: @foreground;
        }
        listview {
          padding: 12px;
          spacing: 4px;
          cycle: false;
        }
        element-text selected {
          background-color: @foreground;
          text-color: @background;
          border-radius: 12px;
        }
        element-text {
          padding: 6px 12px;
          background-color: @background;
          text-color: @foreground;
        }
      '';
    in
    {
      "rofi/apps.rasi".text = ''
        ${rofi-theme}
        configuration {
          drun-display-format: "{name}";
          hover-select: false;
          location: 0;
        }
        listview {
          lines: 4;
        }
        window {
          width: 205px;
          x-offset: 0;
          y-offset: 0;
        }
      '';
      "rofi/bluetooth.rasi".text = ''
        ${rofi-theme}
        window {
          width: 175px;
        }
        listview{
          lines: 6;
        }
        entry {
          enabled: false;
        }
      '';
      "rofi/powermenu.rasi".text = ''
        ${rofi-theme}
        window {
          width: 132px;
        }
        entry {
          enabled: false;
        }
        listview {
          lines: 3;
        }
      '';
      "rofi/wlan.rasi".text = ''
        ${rofi-theme}
        configuration {
          font: "SF Mono Bold 11";
        }
      '';
    };
}
