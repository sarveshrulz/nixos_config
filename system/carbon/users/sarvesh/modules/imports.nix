{...}: {
  imports = [
    ./waybar.nix
    ./rofi.nix
    ./hyprland.nix
    scripts/fnKeys.nix
    scripts/bluetooth.nix
    scripts/powermenu.nix
    scripts/wifimenu.nix
  ];
}