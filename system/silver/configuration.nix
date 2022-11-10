{ pkgs, lib, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
    ./users/sarvesh/user.nix
  ];

  fileSystems =
    let
      options = [ "commit=120" "space_cache=v2" "noatime" "noacl" ];
    in
    {
      "/".options = options ++ [ "compress=zstd:1" "discard=async" "ssd_spread" ];
      "/home" = {
        device = "/dev/disk/by-label/home";
        options = options ++ [ "compress=zstd:1" "autodefrag" "subvol=@home" ];
        encrypted = {
          enable = true;
          label = "crypted-home";
          keyFile = "/home.key";
          blkDev = "/dev/disk/by-label/rawHome";
        };
      };
      "/swaps/swap1" = {
        device = "/dev/disk/by-label/home";
        options = options ++ [ "nodatacow" "subvol=@swap" "autodefrag" ];
      };
      "/swaps/swap2".options = options ++ [ "nodatacow" "discard=async" "ssd_spread" ];
    };

  swapDevices = [
    {
      device = "/swaps/swap1/swapfile";
      size = 1024 * 2;
    }
    {
      device = "/swaps/swap2/swapfile";
      size = 1024 * 6;
    }
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        splashImage = null;
        configurationLimit = 30;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      luks.devices."crypted-nixos" = {
        allowDiscards = true;
        keyFile = "/nixos.key";
      };
      secrets = {
        "nixos.key" = "/etc/secrets/initrd/nixos.key";
        "home.key" = "/etc/secrets/initrd/home.key";
      };
    };
    kernelParams = [ "acpi_backlight=native" ];
    kernelModules = [ "k10temp" ];
  };

  environment.etc = {
    "secrets/initrd/nixos.key" = {
      source = secrets.silver.encryptionKeys.nixos;
      mode = "000";
    };
    "secrets/initrd/home.key" = {
      source = secrets.silver.encryptionKeys.home;
      mode = "000";
    };
  };

  networking.hostName = "silver";

  programs = {
    kdeconnect.enable = true;
    hyprland.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    opengl = {
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
    };
  };

  users.users.root.hashedPassword = secrets.silver.root.password;

  security = {
    rtkit.enable = true;
    pam.services.swaylock = { };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  virtualisation.waydroid.enable = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
