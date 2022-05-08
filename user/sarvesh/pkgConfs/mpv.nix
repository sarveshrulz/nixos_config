{ config, pkgs, ... }: {
  programs.mpv = {
    enable = true;
    config = {
      cscale = "ewa_lanczossharp";
      gpu-context = "wayland";
      hwdec = "auto";
      interpolation = true;
      profile = "gpu-hq";
      save-position-on-quit = true;
      scale = "ewa_lanczossharp";
      tscale = "oversample";
      video-sync = "display-resample";
      vo = "gpu";
    };
  };
}
