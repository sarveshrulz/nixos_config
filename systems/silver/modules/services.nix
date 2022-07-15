{ lib, ... }: {
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    auto-cpufreq.enable = true;
    gvfs.enable = true;
    resolved.enable = false;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    numDevices = 8;
    swapDevices = 8;
  };

  security.rtkit.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
