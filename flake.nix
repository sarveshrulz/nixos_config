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
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprwm-contrib }: {
    nixosConfigurations.silver =
      let
        system = "x86_64-linux";
      in
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          ./system/silver/configuration.nix
        ];
        specialArgs =
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (self: super: {
                  hyprwm-contrib-packages = hyprwm-contrib.packages.${system};
                })
              ];
            };
          in
          {
            inherit pkgs;
          };
      };
    homeConfigurations.ubuntu =
      let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./system/silver-oracle/users/ubuntu/user.nix ];
      };
  };
}
