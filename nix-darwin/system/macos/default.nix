{
  config,
  pkgs,
  ...
}: {
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Make sudo use Touch ID for easier auth
  security.pam.enableSudoTouchIdAuth = true;

  # Following line should allow us to avoid a logout/login cycle
  system = {
    activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
    defaults = {
      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      }; 
      dock = {
        autohide = true;
        mineffect = "scale";
        minimize-to-application = true;
        orientation = "bottom";
        show-process-indicators = true;
        show-recents = false;
        static-only = true;
        tilesize = 64;
        wvous-tl-corner = 2;
        wvous-tr-corner = 2;
      };
      # These don't seem to work
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 5;
      };
      trackpad = {
        Clicking = true;
        Dragging = false;
        TrackpadThreeFingerDrag = false;
      };
    };
    # Remap caps lock to control like a sane person
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

}
