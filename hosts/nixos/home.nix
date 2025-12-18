{ config, pkgs, ... }:

{
  home.username = "home";
  home.homeDirectory = "/home/home";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  home.packages = with pkgs; [
    git
    firefox
    libreoffice
    mpv
    wezterm
    yt-dlp
    transmission_4-qt
    vlc
  ];

  home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # Disable Gnome donation reminder
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };
  };

  home.shellAliases = {
    hms = "home-manager switch -f ~/nixos-config/nixos/home.nix";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
    cleanup = "sudo nix-collect-garbage -d"; 
    sunvim = "sudo -E nvim"; 
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  # IMPORTANT: This must be true for home-manager to write to bashrc
  programs.bash.enable = true; 

  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # --- PRIVACY & TELEMETRY ---
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # --- AI & BLOAT OPT-OUT ---
        "browser.ml.enable" = false;             # Disable local ML engine
        "browser.ml.chat.enabled" = false;       # Disable Chatbot sidebar
        "browser.ml.linkPreview.enabled" = false;# Disable AI link previews
        "browser.tabs.groups.smart.enabled" = false; 
        "extensions.getAddons.showPane" = false; # Hide "Recommendations"
        "browser.discovery.enabled" = false;     # Disable "Pocket" discovery
        
        # --- UX TWEAKS ---
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
      };
    };
  };
    
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "scott96707";
        email = "scott96707@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      color.ui = true;
      push.autoSetupRemote = true;
      safe.directory = "/home/home/nixos-config";

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

  # Git delta - Updates git diff to be modern
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
      options = {
        navigate = true;  # use n/N to jump between changes
          line-numbers = true;
        side-by-side = true;
      };
  };

  programs.home-manager.enable = true;

  # Key for git ssh validation
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
