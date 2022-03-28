{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in {
  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "21.11";
    packages = with pkgs; [
      dunst
      rofi
      picom-next
      alacritty
      sxhkd
      pcmanfm
      polkit_gnome
      xdg-user-dirs
      libnotify
      pamixer
      onlyoffice-bin
      bpytop
      scrot
      killall
      polybarFull
      redshift
      bunnyfetch
      chromium
    ];
  };

  programs = {
    home-manager.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
    fish = {
      enable = true;
      loginShellInit = ''
        if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
          startx
        end
      '';
      shellInit = ''
        set fish_greeting
        bunnyfetch
        alias archlinux="sudo systemd-nspawn --boot -D /home/sarvesh/Arch"
      '';
    };
    git = {
      enable = true;
      userName = "sarveshrulz";
      userEmail = "sarveshkardekar@gmail.com";
    };
  };

  nixpkgs.overlays = [
    (
      self: super: {
        chromium = super.chromium.override {
          commandLineArgs = "--force-dark-mode --enable-deatures=WebUIDarkMode --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-features=VaapiVideoDecoder";
        };
      }
    )
  ];

  services = {
    redshift = {
      enable = true;
      provider = "manual";
      latitude = "19.076090";
      longitude = "72.877426";
    };
  };
}
