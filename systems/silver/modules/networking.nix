{ ... }: {
  networking = {
    hostName = "silver";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    dhcpcd.extraConfig = "nohook resolv.conf";
    nameservers = [ "127.0.0.1" "::1" ];
    resolvconf.enable = false;
  };
}
