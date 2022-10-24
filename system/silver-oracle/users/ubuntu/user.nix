{ pkgs, ... }: {
  home = {
    stateVersion = "22.11";
    username = "ubuntu";
    homeDirectory = /home/ubuntu;
    packages = with pkgs; [ nixpkgs-fmt ];
    file.".ssh" = {
      recursive = true;
      source = ../../../../secrets/silver/sarvesh/ssh;
    };
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
    home-manager.enable = true;
    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
        ${pkgs.pfetch}/bin/pfetch
      '';
      shellAliases = {
        update-flake = "pushd ~/.dotfiles && nix flake update; popd";
        update-system = "pushd ~/.dotfiles && home-manager switch --flake '?submodules=1.#ubuntu'; popd";
        editconf = "vim ~/.dotfiles/system/silver-oracle/users/ubuntu/user.nix";
      };
    };
    git = {
      enable = true;
      userName = "sarveshrulz";
      userEmail = "sarveshkardekar@gmail.com";
      extraConfig.credential.helper = "rbw";
    };
    rbw = {
      enable = true;
      settings = {
        email = "sarveshkardekar+bitwarden@gmail.com";
        pinentry = "tty";
      };
    };
  };
}
