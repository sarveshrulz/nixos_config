{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "vm.dirty_ratio" = 6;
      "vm.dirty_background_ratio" = 3;
      "vm.vfs_cache_pressure" = 50;
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "kvm-amd" "amdgpu" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelParams = [ "nowatchdog" ];
  };
}
