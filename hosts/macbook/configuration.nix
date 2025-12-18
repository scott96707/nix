{ pkgs, ... }: {

  # --- System Identity ---
  users.users.work_machine = {
    name = "work_machine";
    home = "/Users/work_machine";
  };

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # --- macOS Defaults ---
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # --- Nix Core Settings ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.optimise.automatic = true;

  # This makes darwin-rebuild available in your standard path
  services.nix-daemon.enable = true;
  
  # The GID fix for your specific Intel Mac
  ids.gids.nixbld = 350;

  system.stateVersion = 4;
}
