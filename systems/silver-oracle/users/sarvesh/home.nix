{ config, pkgs, ... }: {
  home = {
    username = "sarvesh";
    homeDirectory = "/home/sarvesh";
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
    zsh = {
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
	theme = "daveverwer";
      };
    };
    git = {
      enable = true;
      userName = "sarveshrulz";
      userEmail = "sarveshkardekar@gmail.com";
    };
  };
}
