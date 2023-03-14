{ pkgs, ... }: {
  home-manager.users.sarvesh = {
    services.picom = {
      enable = true;
      package = pkgs.picom-jonaburg;
      settings = {
        corners = {
          corner-radius = 12.0;
          round-borders = 1;
        };
      };
      fade = true;
      fadeSteps = [ 0.025 0.025 ];
      shadow = true;
      shadowOpacity = 0.5;
      # shadowOffsets = [ -10 -10 ];
    };
  };
}
