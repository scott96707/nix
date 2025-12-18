{
  description = "Home Nix Desktop & Macbook Configuration";

  inputs = {
    # 1. Global Nixpkgs (Pinned to Stable 24.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # 2. Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # 3. Darwin (MacOS System Config)
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs: {
    
    # --- LINUX PC (NixOS) ---
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/configuration.nix
      ];
    };

    # --- MACBOOK (Darwin) ---
    # Build with: darwin-rebuild switch --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin"; 
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/macbook/system.nix
        
        # Setup Home Manager as a module for the Mac
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.scott = import ./hosts/macbook/home.nix;
        }
      ];
    };

    # --- STANDALONE HOME (Linux) ---
    homeConfigurations."home" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./hosts/nixos/home.nix ];
    };
  };
}
