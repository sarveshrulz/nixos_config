{ config, pkgs, ... }: {
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
      exec sway
      end
    '';
    shellInit = ''
      set fish_greeting
      ~/.bin/fetch
    '';
    shellAliases = {
      nixupdate = "sudo nix-channel --update && sudo nixos-rebuild switch";
      homeupdate = "nix-channel --update && home-manager switch && nix-collect-garbage -d";
      allupdate = "nixupdate && homeupdate";
    };
  };
}
