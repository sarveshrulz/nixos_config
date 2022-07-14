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
    wirelesstools
    grim
    openssl
    clipman
    wl-clipboard
    virt-manager
    polkit_gnome
    pamixer
    rofi
    xfce.thunar
  ];
}
