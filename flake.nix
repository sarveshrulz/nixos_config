{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
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
                config.allowUnfree = true;
              };
            in
            {
              inherit pkgs;
              inherit secrets;
            };
        };
    };
}
