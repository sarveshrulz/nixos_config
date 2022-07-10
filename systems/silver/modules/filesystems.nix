{ ... }:
let
  f2fsOpts = [
    "compress_algorithm=lz4:6"
    "compress_chksum"
    "atgc"
    "gc_merge"
    "lazytime"
  ];
in {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "f2fs";
      options = f2fsOpts;
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "f2fs";
      options = f2fsOpts;
    };
    "/ssd-storage" = {
      device = "/dev/disk/by-label/ssd-storage";
      fsType = "f2fs";
      options = f2fsOpts;
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
}
