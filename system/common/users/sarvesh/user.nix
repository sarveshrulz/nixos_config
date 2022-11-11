{ pkgs, secrets, ... }: {
  home-manager.users.sarvesh = {
    programs = {
      git = {
        enable = true;
        userName = "sarveshrulz";
        userEmail = "sarveshkardekar@gmail.com";
        extraConfig.credential.helper = "rbw";
      };
      fish = {
        enable = true;
        shellInit = ''
          set fish_greeting
          ${pkgs.pfetch}/bin/pfetch
        '';
      };
      rbw = {
        enable = true;
        settings = {
          email = "sarveshkardekar+bitwarden@gmail.com";
          pinentry = "curses";
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    extraConfig = ''
      no-resolv
      bogus-priv
      strict-order
      server=2a07:a8c1::
      server=45.90.30.0
      server=2a07:a8c0::
      server=45.90.28.0
      add-cpe-id=${secrets.common.sarvesh.dnsId}
    '';
  };

  users.users.sarvesh = {
    description = "Sarvesh Kardekar";
    isNormalUser = true;
    shell = pkgs.fish;
  };
}
