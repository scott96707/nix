{ config, pkgs, lib, ... }:

{
  # --- NIX SETTINGS ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = lib.mkIf pkgs.stdenv.isLinux true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # --- LOCALE & TIME (Defaults) ---
  time.timeZone = "America/Denver";
  i18n.defaultLocale = lib.mkIf pkgs.stdenv.isLinux "en_US.UTF-8";

  # --- CORE SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    jq
    ripgrep
    tree
    unzip
    wget
    nixfmt-rfc-style
  ];

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
    nerd-fonts.jetbrains-mono
  ];
}
