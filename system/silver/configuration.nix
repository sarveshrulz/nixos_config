{ pkgs, lib, ... }:
let
  f2fsOpts = [
    "compress_algorithm=lz4"
    "compress_chksum"
    "atgc"
    "gc_merge"
    "lazytime"
  ];
in
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./users/sarvesh/user.nix
  ];

  fileSystems = {
    "/".options = f2fsOpts;
    "/home".options = f2fsOpts;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "acpi_backlight=native" ];
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
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    opengl = {
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

  security = {
    rtkit.enable = true;
    pam.services.swaylock = { };
  };

  powerManagement = {
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

  virtualisation.waydroid.enable = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
