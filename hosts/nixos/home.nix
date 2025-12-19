{ config, pkgs, ... }:

{
  home.username = "home";
  home.homeDirectory = "/home/home";
  home.stateVersion = "24.11";

  # Shared Modules
  imports = [
    ./../../modules/wezterm.nix
    ./../../modules/git.nix
    ./../../modules/neovim.nix
    ./../../modules/firefox.nix
    ./../../modules/shell.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  home.packages = with pkgs; [
    libreoffice
    mpv
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
    hms = "home-manager switch --flake ~/nixos-config/#home";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
    cleanup = "sudo nix-collect-garbage -d"; 
    sunvim = "sudo -E nvim"; 
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  # IMPORTANT: This must be true for home-manager to write to bashrc
  programs.bash.enable = true; 

  programs.readline = {
    enable = true;
    extraConfig = ''
      # Disable the weird characters during paste
      set enable-bracketed-paste off
      # Readline is how bash terminal handles
      # character inputs
      '';
  };

  programs.home-manager.enable = true;
}
