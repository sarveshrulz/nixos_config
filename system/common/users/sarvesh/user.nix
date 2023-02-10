{ pkgs, secrets, ... }: {
  home-manager.users.sarvesh = {
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

    home = {
      stateVersion = "23.05";
      packages = with pkgs;
        let
          code = pkgs.vscode;
        in
        [
          direnv
          nixpkgs-fmt
          (buildFHSUserEnv {
            name = "code";
            targetPkgs = pkgs: ([ code ]);
            runScript = ''${code}/bin/code'';
            extraInstallCommands = ''ln -s "${code}/share" "$out/"'';
          })
          capitaine-cursors
        ];
    };

    gtk =
      let
        gtkconf = {
          gtk-application-prefer-dark-theme = 1;
          gtk-cursor-theme-name = "capitaine-cursors-white";
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "rgb";
        };
      in
      {
        enable = true;
        font = {
          name = "SF Pro Text";
        };
        theme = {
          package = pkgs.materia-theme;
          name = "Materia-dark-compact";
        };
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-blue-dark";
        };
        gtk4.extraConfig = gtkconf;
        gtk3.extraConfig = gtkconf;
        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme=1
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintfull"
          gtk-xft-rgba="rgb"
          gtk-cursor-theme-name="capitaine-cursors-white"
        '';
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

  users.users.sarvesh = {
    description = "Sarvesh Kardekar";
    extraGroups = [ "wheel" "networkmanager" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
