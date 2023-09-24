{ config, pkgs, modulesPath, secrets, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./users/sarvesh/user.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "acpi_backlight=native" "nowatchdog" "mitigations=off" ];
    kernelPackages = pkgs.linuxPackages_lqx;
    tmp.cleanOnBoot = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap1"; }
    { device = "/dev/disk/by-label/swap2"; }
  ];

  networking = {
    hostName = "carbon";
    networkmanager.enable = true;
  };

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      vimAlias = true;
    };
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    thermald.enable = true;
    fstrim.enable = true;
    auto-cpufreq.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  zramSwap.enable = true;

  time.timeZone = "Asia/Kolkata";

  security = {
    pam.services.swaylock = { };
    rtkit.enable = true;
  };

  users = {
    mutableUsers = false;
    users.root.hashedPassword = secrets.carbon.root.password;
  };

  fonts.fonts = with pkgs; [ noto-fonts font-awesome ];

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
