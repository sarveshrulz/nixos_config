{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  time.timeZone = "Asia/Kolkata";

  users = {
    mutableUsers = false;
    users.root.passwordFile = "${../secrets/rootPassword}";
  };

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
      options = "--delete-older-than 30d";
    };
  };
}
