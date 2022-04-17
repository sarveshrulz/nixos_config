{ config, lib, pkgs, modulesPath, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "f2fs";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "vm.dirty_ratio" = 6;
      "vm.dirty_background_ratio" = 3;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelPackages = unstable.linuxPackages_zen;
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    acpilight.enable = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
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

  networking = {
    hostName = "silver";
    wireless.iwd.enable = true;
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    dhcpcd.extraConfig = "nohook resolv.conf";
    resolvconf.enable = lib.mkForce false;
    nameservers = [ "127.0.0.1" "::1" ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  time.timeZone = "Asia/Kolkata";

  environment.binsh = "${pkgs.dash}/bin/dash";

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$6$VQp0iZV1/rrLMDS8$x83C0JxkQ8WedG0pKUrGHxSW4LDWJUTLhb7V.AGZRO2LL3yvN8ATDRGZyiAhQRFtkvNkAybfLydG9a7Gmo40p0";
      sarvesh = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" ];
        shell = pkgs.fish;
        hashedPassword = "$6$Zwt2/p7axZKbTrAS$TLnZdKjq8D712/Ps1bs2QU2VKVESksTc7cg4t6QDbXKTaA7i5NMJNjcRnwKg6vFVk5qVPO//p8PFniEVfRo8R/";
      };
    };
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
    dconf.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    thermald.enable = true;
    fwupd.enable = true;
    auto-cpufreq.enable = true;
    irqbalance.enable = true;
    earlyoom.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };
    chrony.enable = true;
    gvfs.enable = true;
    resolved.enable = false;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        listen_addresses = [ "127.0.0.1:53" "[::1]:53" ];
        server_names = [ "NextDNS-4392bf" ];
        static."NextDNS-4392bf".stamp = "sdns://AgEAAAAAAAAAAAAOZG5zLm5leHRkbnMuaW8HLzQzOTJiZg";
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = lib.mkForce "dnscrypt-proxy2";

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    numDevices = 8;
    swapDevices = 8;
  };

  security = {
    apparmor.enable = true;
    rtkit.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system = {
    stateVersion = "21.11";
    autoUpgrade.enable = true;
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
