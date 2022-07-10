{ pkgs, ... }: {
  home.packages = with pkgs; [
    bc
    bpytop
    rclone
    firefox-wayland
    pdfsam-basic
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
    virt-manager
    polkit_gnome
    pamixer
    rofi
    xfce.thunar
  ];
}
