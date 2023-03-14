{...}: {
  imports = [
    ./rofi.nix
    ./alacritty.nix
    ./bspwm.nix
    ./dunst.nix
    ./picom.nix
    ./polybar.nix
    ./sxhkd.nix
    scripts/fnKeys.nix
    scripts/bluetooth.nix
    scripts/powermenu.nix
    scripts/wifimenu.nix
  ];
}