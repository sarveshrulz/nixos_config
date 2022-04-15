{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  imports = [
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
      onlyoffice-bin
      pamixer
      xfce.thunar
      nixpkgs-fmt
    ];
    file = {
      ".mozilla/firefox/sarvesh/chrome/userChrome.css".source = ./files/mozilla/firefox/sarvesh/chrome/userChrome.css;
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
  };

  programs = {
    home-manager.enable = true;
  };
}
