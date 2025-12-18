{ config, pkgs, ... }:

{
  # --- NIX SETTINGS ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # --- LOCALE & TIME (Defaults) ---
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- CORE SYSTEM PACKAGES ---
  # These are tools you need on every machine
  environment.systemPackages = with pkgs; [
    curl
    gcc
    git
    htop
    iptables
    jq
    lsof
    neovim
    nixfmt-rfc-style
    ripgrep
    tcpdump
    tree
    unzip
    vim
    wget
    wl-clipboard
  ];

  # --- SHELL & EDITOR ---
  programs.neovim.defaultEditor = true;
  nixpkgs.config.allowUnfree = true;

  # --- FONTS ---
  fonts.packages = with pkgs; [
    noto-fonts 
    noto-fonts-cjk-sans 
    noto-fonts-color-emoji
    liberation_ttf 
    fira-code 
    fira-code-symbols
    nerd-fonts.fira-code
  ];
}
