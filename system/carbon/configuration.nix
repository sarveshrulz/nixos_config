{ config, pkgs, secrets, ... }: {
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
    ./users/sarvesh/user.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelParams = [ "acpi_backlight=native" "nowatchdog" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  fileSystems =
    let
      btrfs-opts = [ "compress=zstd:1" "space_cache=v2" "commit=120" ];
    in
    {
      "/".options = btrfs-opts;
      "/home".options = btrfs-opts;
    };

  networking.hostName = "carbon";

  programs = {
    kdeconnect.enable = true;
    java.enable = true;
  };

  services = {
    gvfs.enable = true;
    thermald.enable = true;
    auto-cpufreq.enable = true;
    tomcat.enable = true;
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };

  hardware = {
    acpilight.enable = true;
    bluetooth.enable = true;
  };

  users.users.root.hashedPassword = secrets.carbon.root.password;
}
