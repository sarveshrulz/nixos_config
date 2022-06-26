{ config, pkgs, ... }: {
  imports = [
    ./pkgConfs/git.nix
    ./pkgConfs/vscode.nix
    ./pkgConfs/zsh.nix
    ./pkgConfs/packages.nix
    ./pkgConfs/file.nix
    ./pkgConfs/mpv.nix
  ];

  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;
}
