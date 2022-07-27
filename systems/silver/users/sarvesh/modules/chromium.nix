{ pkgs, ... }: {
  home.packages = [
    (pkgs.ungoogled-chromium.override {
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        "--process-per-site"
        "--force-dark-mode"
        "--enable-features=WebUIDarkMode"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-features=VaapiVideoDecoder"
      ];
    })
  ];
}
