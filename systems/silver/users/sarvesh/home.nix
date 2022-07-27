{ ... }: {
  imports = [
    modules/chromium.nix
    modules/dunst.nix
    modules/gtk.nix
    modules/fish.nix
    modules/packages.nix
    modules/foot.nix
    modules/git.nix
    modules/vscode.nix
    modules/files.nix
    modules/waybar.nix
    modules/mpv.nix
  ];

  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;
}
