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
      pkgs = { nixpkgs.config.allowUnfree = true; };
    in
    {
      nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          pkgs
          home-manager.nixosModules.home-manager
          ./system/carbon/configuration.nix
        ];
        specialArgs = { inherit secrets; };
      };

      nixosConfigurations.carbon-oracle = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          pkgs
          home-manager.nixosModules.home-manager
          ./system/carbon-oracle/configuration.nix
        ];
        specialArgs = { inherit secrets; };
      };
    };
}
