{ pkgs, ... }: {
  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    acpilight.enable = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
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
}
