{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprwm-contrib, nur }:
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
            nur.nixosModules.nur
            hyprland.nixosModules.default
            home-manager.nixosModules.home-manager
            ./system/carbon/configuration.nix
          ];
          specialArgs =
            let
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [
                  (self: super: {
                    hyprwm-contrib-packages = hyprwm-contrib.packages.${system};
                  })
                ];
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
