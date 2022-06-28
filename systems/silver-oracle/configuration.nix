{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

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
      root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsJIXI87XJaQQ/3R+xRU94RMXi5h0h/EX7N60I9hR3q22+/GF9v/GlijbeEfk0Y3UhXRr/RVUMocJw6YCQf4hUuIt4k4TV7I27myxSIXpxQ3wUf6z7i/HssVXnwnYPVZWQj62OJxVXQQYIKPItTzSpoO7WrYfE/60KOwFD8K61AKM0Jq9+eh5YmOpEGz9CXhdKGtFnpEBnqF8H2TJ1mn1BpnRv9HZDex1KKtJq3NqD+CIAAMgEfCLiYJzfHcYV5cT+NxHLmimdgUcep2f18h6dl1XGCxiiLmf+zQhxWfdqN9W6QefGqIGI+m0xxHFwdz9lbkhJkz2if5venhJPJMQGiwt64Ajw15pVD9LTjW+FUF4DEdY9SUCzYR0rz0h6bP2FWV73b8uNGGmuIWHT5uWtjEBIy2YOsAxRMiyDj8HsZ+pOg20ix0v8opZl5E3W+g2o+7bnFmU86hf6+n4TFg0WpN4FYkeUS7QgCzdZL6usrohgwPK6JfmVP6C7hhRLLHU= sarvesh@silver" ];
      sarvesh = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsJIXI87XJaQQ/3R+xRU94RMXi5h0h/EX7N60I9hR3q22+/GF9v/GlijbeEfk0Y3UhXRr/RVUMocJw6YCQf4hUuIt4k4TV7I27myxSIXpxQ3wUf6z7i/HssVXnwnYPVZWQj62OJxVXQQYIKPItTzSpoO7WrYfE/60KOwFD8K61AKM0Jq9+eh5YmOpEGz9CXhdKGtFnpEBnqF8H2TJ1mn1BpnRv9HZDex1KKtJq3NqD+CIAAMgEfCLiYJzfHcYV5cT+NxHLmimdgUcep2f18h6dl1XGCxiiLmf+zQhxWfdqN9W6QefGqIGI+m0xxHFwdz9lbkhJkz2if5venhJPJMQGiwt64Ajw15pVD9LTjW+FUF4DEdY9SUCzYR0rz0h6bP2FWV73b8uNGGmuIWHT5uWtjEBIy2YOsAxRMiyDj8HsZ+pOg20ix0v8opZl5E3W+g2o+7bnFmU86hf6+n4TFg0WpN4FYkeUS7QgCzdZL6usrohgwPK6JfmVP6C7hhRLLHU= sarvesh@silver" ];
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
