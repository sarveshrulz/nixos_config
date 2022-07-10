{ ... }: {
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
    "/ssd-storage" = {
      device = "/dev/disk/by-label/ssd-storage";
      fsType = "f2fs";
      options = [
        "compress_algorithm=zstd:6"
        "compress_chksum"
        "atgc"
        "gc_merge"
        "lazytime"
      ];
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
