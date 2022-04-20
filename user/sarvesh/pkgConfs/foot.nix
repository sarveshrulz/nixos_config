{ config, pkgs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=8";
        pad = "12x12";
      };
      colors = {
        background = "0a0a0a";
        foreground = "d0d0d0";
        regular0 = "0a0a0a";
        regular1 = "ac4142";
        regular2 = "90a959";
        regular3 = "f4bf75";
        regular4 = "6a9fb5";
        regular5 = "aa759f";
        regular6 = "75b5aa";
        regular7 = "d0d0d0";
        bright0 = "2a2a2a";
        bright1 = "ac4142";
        bright2 = "90a959";
        bright3 = "f4bf75";
        bright4 = "6a9fb5";
        bright5 = "aa759f";
        bright6 = "75b5aa";
        bright7 = "f5f5f5";
      };
    };
  };
}
