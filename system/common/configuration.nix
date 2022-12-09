{ pkgs, secrets, doasedit-git, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    cleanTmpDir = true;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
  };

  networking.networkmanager.enable = true;

  programs = {
    zsh.enable = true;
    git.enable = true;
  };

  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    rnix-lsp
    (writeScriptBin "vim" ''exec ${helix}/bin/hx "$@"'')
    (writeScriptBin "sudo" ''exec doas "$@"'')
    (writeScriptBin "sudoedit" ''exec ${doasedit-git}/doasedit "$@"'')
  ];

  security = {
    apparmor.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{ groups = [ "wheel" ]; persist = true; keepEnv = true; }];
    };
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
