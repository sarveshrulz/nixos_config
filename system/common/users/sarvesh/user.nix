{ pkgs, secrets, ... }: {
  home-manager.users.sarvesh = {
    programs = {
      git = {
        enable = true;
        userName = "sarveshrulz";
        userEmail = "sarveshkardekar@gmail.com";
      };
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
          bpytop = "${pkgs.bpytop}/bin/bpytop";
          edit-conf = "codium ~/.dotfiles";
          update-flake = "pushd ~/.dotfiles && nix flake update; popd";
          update-system = "pushd ~/.dotfiles && git add . && sudo nixos-rebuild -j 8 switch --flake '.?submodules=1#'; popd";
        };
        initExtra = "${pkgs.pfetch}/bin/pfetch";
      };
    };
    home.stateVersion = "22.11";
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

  users.users.sarvesh = {
    description = "Sarvesh Kardekar";
    extraGroups = [ "wheel" "networkmanager" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
