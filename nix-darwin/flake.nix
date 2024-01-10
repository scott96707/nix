{
  description = "Scott's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-darwin.url = "github:nix-community/home-manager/release-23.05";
    home-manager-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = {
    nixpkgs,
    nixpkgs-darwin,
    darwin,
    home-manager,
    home-manager-darwin,
    ...
  } @ inputs: {
    formatter."aarch64-darwin" = nixpkgs.legacyPackages."aarch64-darwin".alejandra;

    nixosConfigurations = {
    };

    darwinConfigurations = {
      scotts-MacBook-Air = import ./hosts/work inputs; # Work Laptop MacBook Pro M1
    };
  };
}
