{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    openssl
    onlyoffice-bin
    firefox-wayland
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    orchis-theme
    tela-circle-icon-theme
    capitaine-cursors
    nixpkgs-fmt
    gnomeExtensions.gsconnect
    gnomeExtensions.bluetooth-quick-connect
  ];
}
