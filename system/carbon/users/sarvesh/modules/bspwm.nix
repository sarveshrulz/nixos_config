{ pkgs, ... }: {
  home-manager.users.sarvesh = {
    xsession = {
      enable = true;
      windowManager.bspwm = {
        enable = true;
	extraConfigEarly = ''
	  pgrep -x sxhkd > /dev/null || ${pkgs.sxhkd}/bin/sxhkd &
          bspc monitor -d I II III IV V VI VII VIII IX X
	'';
        settings = {
          border_width = 0;
          window_gap = 12;
          split_ratio = 0.52;
          borderless_monocle = true;
          gapless_monocle = true;
          focus_follows_pointer = true;
          top_padding = 0;
        };
        startupPrograms = [
          "picom -f"
          "dunst"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
      };
    };
  };
}
