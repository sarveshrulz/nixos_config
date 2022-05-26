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
    kernelPackages =
      let
        linux_clear_pkg = { fetchurl, buildLinux, ... } @ args:
          buildLinux (args // rec {
            stdenv = unstable.clangStdenv;
            version = "5.17.9";
            modDirVersion = version;
            src = fetchurl {
              url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.17.9.tar.gz";
              sha256 = "0gyz40c1blphv9lfml7jkq3hiyjicybw8mf5rp71bn9np8qsjidi";
            };
            kernelPatches = [ ];
          } // (args.argsOverride or { }));
        linux_clear = pkgs.callPackage linux_clear_pkg { };
      in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_clear);
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
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
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
    cpuFreqGovernor = lib.mkForce "powersave";
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
