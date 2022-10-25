{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
      kernelModules = [ "nvme" ];
    };
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  fileSystems = {
    "/boot" = { device = "/dev/disk/by-uuid/DFA2-D49A"; fsType = "vfat"; };
    "/" = { device = "/dev/sda2"; fsType = "ext4"; };
  };
}
