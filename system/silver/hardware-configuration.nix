# Generated by `nixos-generate-config`
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/24aa8de6-6d34-4b03-9bc7-a6b34edba22c";
      fsType = "f2fs";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/b4637964-9b3c-42dc-81bd-168ca37f124b";
      fsType = "f2fs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/036D-7AE9";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/fc9650b9-2384-4a2f-ade9-fded10339553"; }];

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}