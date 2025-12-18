{ config, pkgs, ... }:

{
  home.username = "home";
  home.homeDirectory = "/home/home";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # home-manager is optional here since you use the module
    git
      vlc
  ];

  home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };
  };

  # IMPORTANT: This must be true for home-manager to write your bashrc
  programs.bash.enable = true; 

  programs.home-manager.enable = true;

  # FIX 1: Delta is now its own top-level module (not inside git)
  programs.delta = {
    enable = true;
    enableGitIntegration = true; # Explicitly requested by warning
      options = {
        navigate = true;  # use n/N to jump between changes
          line-numbers = true;
        side-by-side = true;
      };
  };

  programs.git = {
    enable = true;

    # FIX 2: 'aliases' and 'extraConfig' are merged into 'settings' in Unstable
    settings = {
      # Core Config (Formerly extraConfig)
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      color.ui = true;
      push.autoSetupRemote = true;

      # Aliases (Formerly aliases = { ... })
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        type = "cat-file -t";
        dump = "cat-file -p";
      };
    };
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      # Disable the weird characters during paste
      set enable-bracketed-paste off
      # Readline is how bash terminal handles
      # character inputs
      '';
  };
}
