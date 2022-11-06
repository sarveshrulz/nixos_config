{ pkgs, lib, secrets, ... }: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./users/sarvesh/user.nix
  ];

  fileSystems =
    let
      options = [ "compress=zstd:1" "commit=120" "space_cache=v2" "noatime" ];
    in
    {
      "/".options = options ++ [ "ssd" ];
      "/home" = {
        device = "/dev/disk/by-label/home";
        options = options ++ [ "autodefrag" "subvol=@home" ];
        encrypted = {
          enable = true;
          label = "crypted-home";
          keyFile = "/home.key";
          blkDev = "/dev/disk/by-label/rawHome";
        };
      };
    };

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
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
        "nixos.key" = secrets.silver.encryptionKeys.nixos;
        "home.key" = secrets.silver.encryptionKeys.home;
      };
    };
    kernelParams = [ "acpi_backlight=native" ];
    kernelModules = [ "k10temp" ];
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
