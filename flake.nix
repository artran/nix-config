{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
    nixosConfigurations = {
      calcium = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs-unstable;
        };
        modules = [ ./configuration.nix ];
      };
    };

    homeConfigurations = {
      ray = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit pkgs-unstable;
        };
        modules = [ ./home.nix ];
      };
    };
  };
}
