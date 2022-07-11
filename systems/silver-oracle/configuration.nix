{ config, lib, pkgs, modulesPath, ... }: {

  imports = [ (modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    cleanTmpDir = true;
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];

  networking = {
    useDHCP = lib.mkDefault true;
    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    hostName = "silver-oracle";
  };

  environment.binsh = "${pkgs.dash}/bin/dash";

  security.sudo.wheelNeedsPassword = false;

  users = {
    mutableUsers = false;
    users = {
      root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/3PYG9zW9VUt+r+xIoDUfpOBxQDCxyL1uvBSO0gBmp6yfCQL9co280avOXQn4ZnjOgWRR1gjHfz2+T3ejX0KegWLKXi/RdUKHdWQqLhxnL+a22hDn9p61cj/MfD6VWa0sw78brKcJo9jm7t21BtpSxTO5/d+Dk7/ma92YC4/5xa5ERD5152lJNsgM3EXWfQzsZOLPx19VAuy/+pWN+Uw954CmF+7lMW83ZyPIL6XDVUy4J4W3D8XL3Va3nPRBP8LpeP6oO9RitQr6LxbUzN6bAd+3XJc9byNy1+vkbhOn+IYIx4VjgI9e0Gz05/Cm6B3QE/2rrfMpRoMmJV5Fufe69HFGOajtl5wDvODNg1f4e+Rr2C1yzDw7weCwvf87JhPA8zLPHAfldMyw25p8APoi1CxqpvtaTqTSkBP9qCsktkOeM9CofLnyqE/PQCj8+YCB65HJfd4nWtGAJUs3Dp8PaSCcUJ5NhGuC0nBsVIRsBOuM5x3NnZ3Ce/wzc4wrxHs= sarvesh@silver" ];
      sarvesh = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "docker" ];
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/3PYG9zW9VUt+r+xIoDUfpOBxQDCxyL1uvBSO0gBmp6yfCQL9co280avOXQn4ZnjOgWRR1gjHfz2+T3ejX0KegWLKXi/RdUKHdWQqLhxnL+a22hDn9p61cj/MfD6VWa0sw78brKcJo9jm7t21BtpSxTO5/d+Dk7/ma92YC4/5xa5ERD5152lJNsgM3EXWfQzsZOLPx19VAuy/+pWN+Uw954CmF+7lMW83ZyPIL6XDVUy4J4W3D8XL3Va3nPRBP8LpeP6oO9RitQr6LxbUzN6bAd+3XJc9byNy1+vkbhOn+IYIx4VjgI9e0Gz05/Cm6B3QE/2rrfMpRoMmJV5Fufe69HFGOajtl5wDvODNg1f4e+Rr2C1yzDw7weCwvf87JhPA8zLPHAfldMyw25p8APoi1CxqpvtaTqTSkBP9qCsktkOeM9CofLnyqE/PQCj8+YCB65HJfd4nWtGAJUs3Dp8PaSCcUJ5NhGuC0nBsVIRsBOuM5x3NnZ3Ce/wzc4wrxHs= sarvesh@silver" ];
        hashedPassword = "$6$dPWjZ4YJQxL2Koqj$7N2EVHyqhlEHI805Obb6Hm56e0s7QAZT31HFyKVl2otgU.4KAzb2mHPVwzvG/E.tsY9LxtSX8boafESUXWn.m0";
      };
    };
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
    zsh.enable = true;
  };

  services = {
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
    openssh.enable = true;
  };

  virtualisation.docker.enable = true;

  system = {
    stateVersion = "22.05";
    autoUpgrade.enable = true;
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
