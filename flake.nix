{
  description = "Home NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    
    # --- SYSTEM CONFIGURATION (Root) ---
    # Run with: sudo nixos-rebuild switch --flake .#nixos
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/configuration.nix
      ];
    };

    # --- USER CONFIGURATION (Home) ---
    # Run with: home-manager switch --flake .#home
    homeConfigurations."home" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      
      # Pass inputs so you can access them in home.nix if needed
      extraSpecialArgs = { inherit inputs; };
      
      modules = [
        ./hosts/nixos/home.nix
      ];
    };
  };
}
