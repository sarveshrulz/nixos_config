{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelModules = [ "kvm-amd" "amdgpu" ];
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    extraModprobeConfig = "options kvm ignore_msrs=1";
    kernelParams = [ "preempt=voluntary" ];
    kernel.sysctl = {
      "vm.nr_hugepages" = 0;
      "vm.nr_overcommit_hugepages" = 6;
    };
  };
}
