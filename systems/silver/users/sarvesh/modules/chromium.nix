{ pkgs, ... }: {
  home.packages = [
    (pkgs.ungoogled-chromium.override {
      commandLineArgs = [
        "--force-dark-mode"
        "--enable-features=WebUIDarkMode"
        "--ignore-gpu-blocklist"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-features=VaapiVideoDecoder"
      ];
    })
  ];
}
