{ pkgs, secrets, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    tmpOnTmpfs = true;
    initrd.compressor = "lz4";
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
  };

  networking.networkmanager.enable = true;

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
  };

  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    extraConfig = ''
      no-resolv
      bogus-priv
      strict-order
      server=2a07:a8c1::
      server=45.90.30.0
      server=2a07:a8c0::
      server=45.90.28.0
      add-cpe-id=${secrets.common.sarvesh.dnsId}
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  time.timeZone = "Asia/Kolkata";

  users.mutableUsers = false;

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
