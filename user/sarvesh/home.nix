{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  imports = [
    ./pkgConfs/dunst.nix
    ./pkgConfs/fish.nix
    ./pkgConfs/firefox.nix
    ./pkgConfs/foot.nix
    ./pkgConfs/git.nix
    ./pkgConfs/sway.nix
    ./pkgConfs/vscode.nix
    ./pkgConfs/waybar.nix
  ];

  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "21.11";
    packages = with pkgs; [
      bpytop
      nixpkgs-fmt
      onlyoffice-bin
      pamixer
      rofi
      xfce.thunar
      bc
    ];
  };

  xdg.configFile = {
    "sway/scripts/brightness.sh" = {
      executable = true;
      source = ./files/config/sway/scripts/brightness.sh;
    };
    "sway/scripts/volume.sh" = {
      executable = true;
      source = ./files/config/sway/scripts/volume.sh;
    };
    "rofi/scripts/rofi-power-menu" = {
      executable = true;
      source = ./files/config/rofi/scripts/rofi-power-menu;
    };
    "rofi/scripts/rofi-bluetooth" = {
      executable = true;
      source = ./files/config/rofi/scripts/rofi-bluetooth;
    };
    "rofi/scripts/rofi-wifi-menu" = {
      executable = true;
      source = ./files/config/rofi/scripts/rofi-wifi-menu;
    };
    "fish/functions/fish_prompt.fish".source = ./files/config/fish/functions/fish_prompt.fish;
    "rofi/apps.rasi".source = ./files/config/rofi/apps.rasi;
    "rofi/powermenu.rasi".source = ./files/config/rofi/powermenu.rasi;
    "rofi/bluetooth.rasi".source = ./files/config/rofi/bluetooth.rasi;
    "rofi/wlan.rasi".source = ./files/config/rofi/wlan.rasi;
    "dunst/icons/brightness.png".source = ./files/config/dunst/icons/brightness.png;
    "dunst/icons/muted.png".source = ./files/config/dunst/icons/muted.png;
    "dunst/icons/volume.png".source = ./files/config/dunst/icons/volume.png;
  };

  programs = {
    home-manager.enable = true;
  };
}
