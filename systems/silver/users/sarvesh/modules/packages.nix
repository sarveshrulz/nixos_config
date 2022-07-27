{ pkgs, ... }: {
  home.packages = with pkgs; [
    bc
    bpytop
    rclone
    tldr
    capitaine-cursors
    swaybg
    killall
    nixpkgs-fmt
    gammastep
    onlyoffice-bin
    grim
    clipman
    wl-clipboard
    mate.eom
    polkit_gnome
    pamixer
    rofi
    xfce.thunar
    swaylock-effects
  ];
}
