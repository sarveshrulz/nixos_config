{ pkgs, lib, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
    ./users/sarvesh/user.nix
  ];

  fileSystems."/".options = [ "noatime" "commit=120" ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      kernelModules = [ "dm-cache" "dm-cache-smq" "dm-cache-mq" "dm-cache-cleaner" ];
      luks.devices = {
        "crypted-ssd".device = "/dev/disk/by-label/ssd";
        "crypted-hdd".device = "/dev/disk/by-label/hdd";
      };
    };
    kernelParams = [ "acpi_backlight=native" ];
    kernelModules = [ "k10temp" "dm-cache" "dm-cache-smq" "dm-persistent-data" "dm-bio-prison" "dm-clone" "dm-crypt" "dm-writecache" "dm-mirror" "dm-snapshot" ];
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
    lvm = {
      boot.thin.enable = true;
      dmeventd.enable = true;
    };
    fstrim.enable = true;
    hdapsd.enable = true;
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

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
