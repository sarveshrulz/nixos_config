{ config, pkgs, ... }: {
  home.file = {
    ".local/share/applications/org.gnome.Console.desktop".text = ''
      [Desktop Entry]
      Name=Console
      Exec=kgx
      Icon=org.gnome.Terminal
      Keywords=command;prompt;cmd;commandline;run;shell;terminal;kgx;kings cross;
      Terminal=false
      Type=Application
      Categories=System;TerminalEmulator;X-GNOME-Utilities;GTK;GNOME;
      StartupNotify=true
      DBusActivatable=true
      X-GNOME-UsesNotifications=true
      Actions=new-window;new-tab;
      X-Purism-FormFactor=Workstation;Mobile;
      [Desktop Action new-window]
      Exec=kgx
      Name=New Window
      Icon=window-new
      [Desktop Action new-tab]
      Exec=kgx --tab
      Name=New Tab
      Icon=tab-new
    '';
    ".local/share/applications/nixos-manual.desktop".text = "NoDisplay=true";
  };
}
