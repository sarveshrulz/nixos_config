{ pkgs, ... }: {
  home.packages = with pkgs; [
    bc
    bpytop
    rclone
    firefox-wayland
    tldr
    capitaine-cursors
    swaybg
    killall
    nixpkgs-fmt
    gammastep
    onlyoffice-bin
    grim
    openssl
    clipman
    wl-clipboard
    polkit_gnome
    pamixer
    rofi
    xfce.thunar
  ];
}
