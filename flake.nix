{
  description = "Home MLOps NixOS Configuration";

  inputs = {
    # 1. Main System (Using Unstable for latest MLOps/Gaming hardware support)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.home = import ./hosts/nixos/home.nix;
        }
      ];
    };
  };
}
