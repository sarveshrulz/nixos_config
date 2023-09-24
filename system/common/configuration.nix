{ config, ... }: {
  boot.tmp.cleanOnBoot = true;

  networking.networkmanager.enable = true;

  programs = {
    zsh.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      vimAlias = true;
    };
  };

  services.openssh.enable = true;

  zramSwap.enable = true;

  time.timeZone = "Asia/Kolkata";

  users.mutableUsers = false;

  system = {
    stateVersion = "23.05";
    autoUpgrade.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
