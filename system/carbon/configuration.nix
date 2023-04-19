{ config, pkgs, modulesPath, secrets, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/configuration.nix
    ./users/sarvesh/user.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot.enable = true;
    };
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "acpi_backlight=native" "nowatchdog" ];
    kernelPackages = pkgs.linuxPackages_zen;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "compress=zstd:1" "space_cache=v2" "commit=120" ];
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap1"; }
    { device = "/dev/disk/by-label/swap2"; }
  ];

  networking.hostName = "carbon";

  programs.hyprland.enable = true;

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    thermald.enable = true;
    fstrim.enable = true;
    auto-cpufreq.enable = true;
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  users.users.root.hashedPassword = secrets.carbon.root.password;

  security.pam.services.swaylock = { };

  fonts.fonts = [
    config.nur.repos.oluceps.san-francisco
    pkgs.font-awesome
  ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
