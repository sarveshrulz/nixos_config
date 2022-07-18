{ pkgs, ... }: {
  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$6$VQp0iZV1/rrLMDS8$x83C0JxkQ8WedG0pKUrGHxSW4LDWJUTLhb7V.AGZRO2LL3yvN8ATDRGZyiAhQRFtkvNkAybfLydG9a7Gmo40p0";
      sarvesh = {
        description = "Sarvesh Kardekar";
        isNormalUser = true;
        extraGroups = [ "wheel" "video" "libvirtd" ];
        shell = pkgs.fish;
        hashedPassword = "$6$Zwt2/p7axZKbTrAS$TLnZdKjq8D712/Ps1bs2QU2VKVESksTc7cg4t6QDbXKTaA7i5NMJNjcRnwKg6vFVk5qVPO//p8PFniEVfRo8R/";
      };
    };
  };
}
