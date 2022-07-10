{ pkgs, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;
in
{
  imports = [ hyprland.nixosModules.default ];

  nixpkgs.overlays = [ hyprland.overlays.default ];

  environment.binsh = "${pkgs.dash}/bin/dash";

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
      extraPackages = [ ];
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  virtualisation.libvirtd.enable = true;
}
