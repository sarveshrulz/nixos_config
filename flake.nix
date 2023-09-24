{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager }:
    let
      secrets = import ./secrets/secrets.nix;
    in
    {
      nixosConfigurations.carbon =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            ./system/carbon/configuration.nix
          ];
          specialArgs =
            let
              pkgs = import nixpkgs {
                inherit system;
                config = {
                  allowUnfree = true;
                  packageOverrides = pkgs: with pkgs; {
                    unstable = import unstable { inherit system; };
                  };
                };
              };
            in
            {
              inherit pkgs;
              inherit secrets;
            };
        };

      nixosConfigurations.carbon-oracle = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          let
            pkgs = { nixpkgs.config.allowUnfree = true; };
          in
          [
            pkgs
            home-manager.nixosModules.home-manager
            ./system/carbon-oracle/configuration.nix
          ];
        specialArgs = { inherit secrets; };
      };
    };
}
