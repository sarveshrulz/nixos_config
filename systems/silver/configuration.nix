{ config, lib, pkgs, modulesPath, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  disabledModules = [ "virtualisation/waydroid.nix" ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    <nixos-unstable/nixos/modules/virtualisation/waydroid.nix>
  ];

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
    "/home/sarvesh/.cache/mozilla/firefox" = {
      device = "tmpfs";
      fsType = "tmpfs";
      noCheck = true;
      options = [
        "noatime"
        "nodev"
        "nosuid"
        "size=128M"
      ];
    };
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" "amdgpu" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelParams = [ "nowatchdog" "cgroup_no_v1=all" "systemd.unified_cgroup_hierarchy=yes" ];
    kernel.sysctl = {
      "vm.swappiness" = 90;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_ratio" = 20;
      "vm.dirty_ratio" = 50;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
    };
  };

  networking = {
    hostName = "silver";
    networkmanager.dns = "none";
    nameservers = [ "127.0.0.1" "::1" ];
    firewall = {
      allowedUDPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  time.timeZone = "Asia/Kolkata";

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$6$VQp0iZV1/rrLMDS8$x83C0JxkQ8WedG0pKUrGHxSW4LDWJUTLhb7V.AGZRO2LL3yvN8ATDRGZyiAhQRFtkvNkAybfLydG9a7Gmo40p0";
      sarvesh = {
        description = "Sarvesh Kardekar";
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "networkmanager" ];
        hashedPassword = "$6$Zwt2/p7axZKbTrAS$TLnZdKjq8D712/Ps1bs2QU2VKVESksTc7cg4t6QDbXKTaA7i5NMJNjcRnwKg6vFVk5qVPO//p8PFniEVfRo8R/";
      };
    };
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      waydroid = unstable.waydroid;
    }; 
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    zsh.enable = true;
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    gnome.excludePackages = (with pkgs; [
      gnome-text-editor
      baobab
      gnome-usage
      gnome-connections
      evince
      epiphany
    ]) ++ (with pkgs.gnome; [
      gnome-contacts
      gnome-clocks
      gnome-calculator
      gnome-weather
      gnome-maps
      gnome-calendar
      gnome-disk-utility
      gnome-music
      gnome-logs
      eog
      geary
      simple-scan
      totem
      yelp
      cheese
    ]);
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    auto-cpufreq.enable = true;
    resolved.enable = false;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };
  };

  security.rtkit.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };

  system = {
    stateVersion = "22.05";
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
