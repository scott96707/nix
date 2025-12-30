{ config, pkgs, ... }:

{
  home.username = "home";
  home.homeDirectory = "/home/home";
  # Leave stateVersion alone. It is auto generated and determines
  # file structure format.
  home.stateVersion = "24.11";

  # Shared Modules
  imports = [
    ./../../modules/firefox.nix
    ./../../modules/git.nix
    ./../../modules/neovim.nix
    ./../../modules/shell.nix
    ./../../modules/vscode.nix
    ./../../modules/wezterm.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  home.packages = with pkgs; [
    age
    gcc
    iptables
    libreoffice
    lsof
    mpv
    sops
    tcpdump
    transmission_4-qt
    vlc
    wl-clipboard 
    yt-dlp
  ];

  home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # Disable Gnome donation reminder
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };
  };

  home.shellAliases = {
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
