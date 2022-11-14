{ pkgs, secrets, ... }: {
  imports = [ ../../../common/users/sarvesh/user.nix ];

  home-manager.users.sarvesh = {
    home.file = {
      ".ssh/id_rsa".text = secrets.silver-oracle.sarvesh.sshKeys.private;
      ".ssh/id_rsa.pub".text = secrets.silver-oracle.sarvesh.sshKeys.public;
    };
    programs.fish = {
      shellAliases = {
        update-flake = "pushd ~/.dotfiles && nix flake update; popd";
        update-system = "pushd ~/.dotfiles && ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt (find -type f -name '*.nix') && git add . && sudo nixos-rebuild --install-bootloader -j 8 switch --flake '.?submodules=1#'; popd";
        edit-conf = "vim ~/.dotfiles/system/silver-oracle/configuration.nix";
        edit-user = "vim ~/.dotfiles/system/silver-oracle/users/sarvesh/user.nix";
      };
    };
  };

  users.users.sarvesh = {
    extraGroups = [ "wheel" ];
    hashedPassword = secrets.silver-oracle.sarvesh.password;
    openssh.authorizedKeys.keys = [ secrets.silver-oracle.sarvesh.sshKeys.public ];
  };
}
