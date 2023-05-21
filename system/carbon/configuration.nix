{ config, pkgs, modulesPath, secrets, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/configuration.nix
    ./users/sarvesh/user.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
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
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "xfs";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap1"; }
    { device = "/dev/disk/by-label/swap2"; }
  ];

  networking.hostName = "carbon";

  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
    thermald.enable = true;
    fstrim.enable = true;
    auto-cpufreq.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  users.users.root.hashedPassword = secrets.carbon.root.password;
}
