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
      ani-cli = "sh ~/.local/ani-cli/bin/ani-cli -f 6";
      silver-oracle = "ssh sarvesh@152.67.4.198";
    };
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };
  };
}
