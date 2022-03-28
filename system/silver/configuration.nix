{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems= {
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

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_testing;
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "quiet" "nowatchdog" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    acpilight.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
  };
  
  networking = {
    hostName = "silver";
    wireless.iwd.enable = true;
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    nameservers = [ "45.90.28.135" "45.90.30.135" "1.1.1.1" "8.8.8.8" "1.0.0.1" "8.8.4.4" ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  time.timeZone = "Asia/Kolkata";

  environment = {
    systemPackages = with pkgs; [ dash ];
    binsh = "${pkgs.dash}/bin/dash";
  };

  users = {
    mutableUsers = false;
    users = {
      sarvesh = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" ];
        shell = pkgs.fish;
        hashedPassword = "$6$Zwt2/p7axZKbTrAS$TLnZdKjq8D712/Ps1bs2QU2VKVESksTc7cg4t6QDbXKTaA7i5NMJNjcRnwKg6vFVk5qVPO//p8PFniEVfRo8R/";
      };
      root.hashedPassword = "$6$VQp0iZV1/rrLMDS8$x83C0JxkQ8WedG0pKUrGHxSW4LDWJUTLhb7V.AGZRO2LL3yvN8ATDRGZyiAhQRFtkvNkAybfLydG9a7Gmo40p0";
    };
  };

  programs= {
    neovim = {
      enable = true;
      vimAlias = true;
      configure.customRC = ''
        set number
      '';
    };
    fish.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      deviceSection = ''
        Option "TearFree" "true"
      '';
      displayManager.startx.enable = true;
      desktopManager.xterm.enable = false;
      windowManager.bspwm.enable = true;
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
	  disableWhileTyping = true;
	  accelProfile = "adaptive";
	  accelSpeed = "0.1";
        };
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    thermald.enable = true;
    fwupd.enable = true;
    auto-cpufreq.enable = true;
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
