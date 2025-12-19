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
  
  # Must install homebrew manually on MacOS before using and modules:
  # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  homebrew = {
    enable = true;

    onActivation.cleanup = "zap"; # Uninstalls apps not in this list
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    casks = [
      "firefox"
      "rectangle"
    ];
  };

  # --- macOS Defaults ---
  system.defaults = {

    # Control the Dock
    dock = {
      autohide = true;
      show-recents = false; # Clean up the dock
      mru-spaces = false;   # Stop macOS from rearranging your Spaces/Desktops
      orientation = "bottom";
      tilesize = 64;
    };

    # Mission Control Settings
    spaces.spans-displays = false; # false = "Displays have separate Spaces" is ON

    # Control Finder
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true; # Show full path in Finder title bar
      FXEnableExtensionChangeWarning = false; # Stop annoying "Are you sure you want to change extension"
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    CustomUserPreferences = {
      "com.apple.controlcenter" = {
        "NSStatusItem Visible Weather" = true;
      };
    };
    # General UI/UX
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15; # Fast key repeat (essential for Vim users)

      # Set to false to show the menu bar at all times
      # Set to true if you ever want it to autohide
      _HIHideMenuBar = false;
      KeyRepeat = 2;         # Fast key repeat
      "com.apple.mouse.tapBehavior" = 1; # Enable tap-to-click
      AppleInterfaceStyle = "Dark"; # Force Dark Mode

    };
    
    # Login and Security
    loginwindow.GuestEnabled = false;
  };

  # --- Nix Core Settings ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.optimise.automatic = true;
  nix.optimise.user = "work_machine";

  # This makes darwin-rebuild available in the standard path
  services.nix-daemon.enable = true;
  
  # The GID fix for this specific Intel Mac
  ids.gids.nixbld = 350;

  security.sudo.extraConfig = ''
    # Allow work_machine to run darwin-rebuild without a password
    work_machine ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild
    # Also allow the underlying nix-build command if needed
    work_machine ALL=(ALL) NOPASSWD: /nix/var/nix/profiles/default/bin/nix-build
  '';

  system.stateVersion = 4;
}
