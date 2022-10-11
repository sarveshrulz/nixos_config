{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    wireless.iwd.enable = true;
    dhcpcd.extraConfig = "nohook resolv.conf";
    nameservers = [ "127.0.0.1" "::1" ];
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    fish.enable = true;
  };

  services = {
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
    resolved.enable = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  time.timeZone = "Asia/Kolkata";

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$6$VQp0iZV1/rrLMDS8$x83C0JxkQ8WedG0pKUrGHxSW4LDWJUTLhb7V.AGZRO2LL3yvN8ATDRGZyiAhQRFtkvNkAybfLydG9a7Gmo40p0";
  };

  system = {
    stateVersion = "22.11";
    autoUpgrade.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
