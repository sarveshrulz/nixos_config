{ pkgs, lib, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
    ./users/sarvesh/user.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelParams = [ "acpi_backlight=native" "nowatchdog" ];
    kernelModules = [ "k10temp" ];
  };

  fileSystems =
    let
      f2fs-opts = [ "compress_algorithm=zstd:6" "compress_chksum" "atgc" "gc_merge" "lazytime" ];
    in
    {
      "/".options = f2fs-opts;
      "/home".options = f2fs-opts;
    };

  networking.hostName = "silver";

  programs = {
    kdeconnect.enable = true;
    hyprland.enable = true;
  };

  services = {
    ananicy.enable = true;
    irqbalance.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
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
