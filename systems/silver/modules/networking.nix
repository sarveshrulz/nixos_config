{ lib, ... }: {
  networking = {
    hostName = "silver";
    wireless.iwd.enable = true;
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    dhcpcd.extraConfig = "nohook resolv.conf";
    resolvconf.enable = lib.mkForce false;
    nameservers = [ "127.0.0.1" "::1" ];
  };
}
