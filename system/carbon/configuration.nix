{ config, pkgs, secrets, ... }: {
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
    kernelParams = [ "acpi_backlight=native" "nowatchdog" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  fileSystems =
    let
      f2fs-opts = [ "compress_algorithm=zstd:6" "compress_chksum" "atgc" "gc_merge" "lazytime" ];
    in
    {
      "/".options = f2fs-opts;
      "/home".options = f2fs-opts;
    };

  networking.hostName = "carbon";

  programs = {
    kdeconnect.enable = true;
    hyprland.enable = true;
    java.enable = true;
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    thermald.enable = true;
    fstrim.enable = true;
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    tlp = {
      enable = true;
      settings.USB_EXCLUDE_BTUSB = 1;
    };
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    opengl = {
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
