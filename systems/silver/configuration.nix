{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    modules/filesystems.nix
    modules/boot.nix
    modules/hardware.nix
    modules/networking.nix
    modules/locale.nix
    modules/users.nix
    modules/packages.nix
    modules/services.nix
  ];

  system = {
    stateVersion = "22.05";
    autoUpgrade.enable = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
