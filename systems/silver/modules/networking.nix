{ ... }: {
  networking = {
    hostName = "silver";
    wireless.iwd.enable = true;
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    dhcpcd.extraConfig = "nohook resolv.conf";
    nameservers = [ "127.0.0.1" "::1" ];
  };
}
