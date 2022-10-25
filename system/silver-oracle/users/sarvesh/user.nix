{ pkgs, ... }: {
  home-manager.users.sarvesh = {
    home = {
      stateVersion = "22.11";
      file.".ssh" = {
        recursive = true;
        source = ../../../../secrets/silver-oracle/sarvesh/ssh;
      };
    };

    programs = {
      fish = {
        enable = true;
        shellInit = ''
          set fish_greeting
          ${pkgs.pfetch}/bin/pfetch
        '';
        shellAliases = {
          update-flake = "pushd ~/.dotfiles && nix flake update; popd";
          update-system = "pushd ~/.dotfiles && ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt (find -type f -name '*.nix') && git add . && sudo nixos-rebuild switch --flake '.?submodules=1#'; popd";
        };
      };
      git = {
        enable = true;
        userName = "sarveshrulz";
        userEmail = "sarveshkardekar@gmail.com";
        extraConfig.credential.helper = "rbw";
      };
      rbw = {
        enable = true;
        settings = {
          email = "sarveshkardekar+bitwarden@gmail.com";
          pinentry = "tty";
        };
      };
    };
  };

  users.users.sarvesh = {
    description = "Sarvesh Kardekar";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    passwordFile = "${../../../../secrets/silver-oracle/sarvesh/sarveshPassword}";
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDksSd2571cu+MZ069N88t6itzDxhpwGg5D4884sAnNVhirDvC/OwPKK4Fq/GCGRZlK0l3PZNkl5yxmHSIA4IJJYod2hYCPCw68HJMc1QWn+yKXqatRdr8u5apIHeoQU0Pzytfp/oEm8A+erm9jCZ9kLrWi5Wptqq8VT1qoCR8nzGlDCMjH4NK9rTdNP2qqDSBgOcZyTPxH7G6WlFYt/oXoQRYdPQ7i7njW5K0rdrq0vlzlPyKvRsgQD4OsYNsSf8fpnlGSDPbrGb6ANiM/Uz9kZCNgl9SYsihzYSDvg/9u9j4ilInJ1UveD8F52TCSnbrM5JPIA7Hp6jbeTef/7l4rNZx7WGoxBOQwbF5AW0N+LH/tUvm3+R/CMfOETgUbjwEKU84D8k8ABWrnLB1p4F/QbJt8xwaLC9bd+Uw0KIN92QmUtKsMMrx6htDRJ3CVsfPIjckwn7nTVUkAY9UIjZ/JlL2N2VLpgQ3mgSfk5xu6E9SKscxwiG6VIebcl/lHjtc= sarvesh@silver" ];
  };
}
