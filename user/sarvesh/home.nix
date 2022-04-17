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
    ];
    file = {
      ".bin/fetch" = {
        executable = true;
        source = ./files/bin/fetch;
      };
    };
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
    "fish/functions/fish_prompt.fish".source = ./files/config/fish/functions/fish_prompt.fish;
    "fetch/conf".source = ./files/config/fetch/conf;
    "rofi/apps.rasi".source = ./files/rofi/apps.rasi;
  };

  programs = {
    home-manager.enable = true;
  };
}
