{
  description = "Multi-platform Nix Configuration (NixOS Desktop & Intel MacBook)";

  inputs = {
    # Using Stable 24.11 for reliability
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }: {
    
    # --- 1. LINUX PC (NixOS) ---
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/nixos/configuration.nix ];
    };

    # --- 2. MACBOOK (Darwin) ---
    # Build command: nix run nix-darwin -- switch --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin"; 
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/macbook/configuration.nix
        
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.work_machine = import ./hosts/macbook/home.nix;
        }
      ];
    };

    # --- 3. STANDALONE HOME (Linux) ---
    homeConfigurations."home" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./hosts/nixos/home.nix ];
    };
  };
}
