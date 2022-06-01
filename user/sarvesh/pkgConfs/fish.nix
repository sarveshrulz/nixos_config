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
      sh ${builtins.fetchurl https://raw.githubusercontent.com/Manas140/fetch/main/fetch} -c ${builtins.fetchurl https://raw.githubusercontent.com/Manas140/fetch/main/conf/left} | sed 's||->|g'
    '';
    shellAliases = {
      nixupdate = "sudo nix-channel --update && sudo nixos-rebuild switch";
      homeupdate = "nix-channel --update && home-manager switch && nix-collect-garbage -d";
      allupdate = "nixupdate && homeupdate";
      ani-cli = "sh ${builtins.fetchurl https://raw.githubusercontent.com/pystardust/ani-cli/master/ani-cli} -q best";
    };
  };
}
