{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      sh ${pkgs.pfetch}/bin/pfetch
    '';
    shellAliases = {
      nixupdate = "sudo nix-channel --update && sudo nixos-rebuild switch";
      homeupdate = "nix-channel --update && home-manager switch && nix-collect-garbage -d";
      allupdate = "nixupdate && homeupdate";
    };
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };
  };
}
