{ pkgs, secrets, ... }: {
  home-manager.users.sarvesh = {
    home = {
      packages = with pkgs; [
        vscode-fhs
        direnv
        nixpkgs-fmt
      ];
      file = {
        ".ssh/id_rsa".text = secrets.carbon.sarvesh.sshKeys.private;
        ".ssh/id_rsa.pub".text = secrets.carbon.sarvesh.sshKeys.public;
      };
      stateVersion = "23.05";
    };

    programs = {
      gh.enable = true;
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        oh-my-zsh = {
          enable = true;
          theme = "bira";
        };
        shellAliases = {
          edit-conf = "code ~/.dotfiles";
          update-flake = "pushd ~/.dotfiles && nix flake update; popd";
          update-system = "pushd ~/.dotfiles && git add . && sudo nixos-rebuild -j 8 switch --flake '.?submodules=1#'; popd";
        };
        initExtra = "${pkgs.pfetch}/bin/pfetch";
      };
    };
  };

  networking.networkmanager.dns = "dnsmasq";

  environment.etc."NetworkManager/dnsmasq.d/dnsmasq.conf".text = ''
    no-resolv
    bogus-priv
    strict-order
    server=2a07:a8c1::
    server=45.90.30.0
    server=2a07:a8c0::
    server=45.90.28.0
    add-cpe-id=${secrets.common.sarvesh.dnsId}
  '';

  fileSystems = {
    "/home/sarvesh/.cache/chromium" = {
      device = "tmpfs";
      fsType = "tmpfs";
      noCheck = true;
      options = [
        "noatime"
        "nodev"
        "nosuid"
        "size=128M"
      ];
    };
  };

  users.users.sarvesh = {
    hashedPassword = secrets.carbon.sarvesh.password;
    description = "Sarvesh Kardekar";
    extraGroups = [ "wheel" "networkmanager" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
