{ pkgs, secrets, ... }: {
  boot.cleanTmpDir = true;

  networking.networkmanager.enable = true;

  programs = {
    zsh.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      vimAlias = true;
    };
  };

  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };
  };

  zramSwap.enable = true;

  time.timeZone = "Asia/Kolkata";

  users.mutableUsers = false;

  documentation.nixos.enable = false;

  system = {
    stateVersion = "22.11";
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
